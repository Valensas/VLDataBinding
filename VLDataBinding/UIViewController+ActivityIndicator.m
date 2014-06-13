//
//  UIViewController+ActivityIndicator.m
//  VLBinding
//
//  Created by Can Yaman on 05/06/14.
//  Copyright (c) 2014 Valensas. All rights reserved.
//

#import "UIViewController+ActivityIndicator.h"
#import "ActivityIndicatorView.h"
#import <objc/runtime.h>

static void * const OperationKey = (void*)&OperationKey;
static void * const ActivityIndicatorKey = (void*)&ActivityIndicatorKey;
static void * const ActivityIndicatorLabelKey = (void*)&ActivityIndicatorLabelKey;
static void * const ActivityIndicatorCoverKey = (void*)&ActivityIndicatorCoverKey;


@implementation UIViewController (ActivityIndicator)

+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL viewWillAppearSelector = @selector(viewWillAppear:);
        SEL viewWillDisappearSelector =  @selector(viewWillDisappear:);
        
        SEL _vl_viewWillAppearSelector = @selector(_vl_viewWillAppear:);
        SEL _vl_viewWillDisappearSelector =  @selector(_vl_viewWillDisappear:);
        
        Method viewWillAppearMethod = class_getInstanceMethod(self, viewWillAppearSelector);
        Method viewWillDisappearMethod = class_getInstanceMethod(self, viewWillDisappearSelector);
        
        
        Method _vl_viewWillAppearMethod = class_getInstanceMethod(self, _vl_viewWillAppearSelector);
        Method _vl_viewWillDisappearMethod = class_getInstanceMethod(self, _vl_viewWillDisappearSelector);
        
        method_exchangeImplementations(viewWillAppearMethod, _vl_viewWillAppearMethod);
        method_exchangeImplementations(viewWillDisappearMethod, _vl_viewWillDisappearMethod);
    });
}

- (void)_vl_viewWillAppear:(BOOL)animated{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.operation!=nil) {
            if (![self.operation isFinished]) {
                NSLog(@"viewWillAppear operation exist");
                [self displayActivityView:nil];
            }
        }
    });
    [self _vl_viewWillAppear:animated];
}
-(void)_vl_viewWillDisappear:(BOOL)animated{
    NSLog(@"View Did Disappear");
    if(self.activityIndicatorView.operation){
        [self removeActivityViewWithAnimation:NO];
    }
    [self _vl_viewWillDisappear:animated];
}

-(void)removeActivityViewWithAnimation:(BOOL)animation{
    NSLog(@"Remove ActivityView WithAnimation");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.activityIndicatorView removeActivityViewWithAnimation:animation];
    });
}
-(IBAction)displayActivityView:(NSString *)label{
    dispatch_async(dispatch_get_main_queue(), ^{

    UIView *viewToUse = self.view;
    
    // Perhaps not the best way to find a suitable view to cover the navigation bar as well as the content?
    if (self.activityIndicatorCoverNavBar)
        viewToUse = self.navigationController.navigationBar.superview;
    
    if (self.activityIndicatorLabel)
    {
        // Display the appropriate activity style, with custom label text.  The width can be omitted or zero to use the text's width:
        self.activityIndicatorView=[[ActivityIndicatorView alloc] initWithOperation:self.operation viewToUse:viewToUse label:self.activityIndicatorLabel];
    }
    else
    {
        // Display the appropriate activity style, with the default "Loading..." text:
        self.activityIndicatorView=[[ActivityIndicatorView alloc] initWithOperation:self.operation viewToUse:viewToUse];
    }
    });

}

//operation property
-(void)setOperation:(id)operation {
    if (operation) {
        [self displayActivityView:nil];
    }else{
        [self removeActivityViewWithAnimation:NO];
    }
    objc_setAssociatedObject(self, OperationKey, operation, OBJC_ASSOCIATION_RETAIN);
    //activityIndicatorObserve operation status
}
-(id)operation{
    return objc_getAssociatedObject(self, OperationKey);
}
//activityIndicatorLabel
-(void)setActivityIndicatorView:(ActivityIndicatorView *)activityIndicatorView {
    objc_setAssociatedObject(self, ActivityIndicatorKey, activityIndicatorView, OBJC_ASSOCIATION_RETAIN);
}
-(ActivityIndicatorView *)activityIndicatorView{
    return objc_getAssociatedObject(self, ActivityIndicatorKey);
}
//activityIndicatorLabel
-(void)setActivityIndicatorLabel:(NSString *)activityIndicatorLabel {
    if (self.activityIndicatorView) {
        self.activityIndicatorView.label=activityIndicatorLabel;
    }
    objc_setAssociatedObject(self, ActivityIndicatorLabelKey, activityIndicatorLabel, OBJC_ASSOCIATION_RETAIN);
}
-(NSString*)activityIndicatorLabel{
    return objc_getAssociatedObject(self, ActivityIndicatorLabelKey);
}
//activityIndicatorCoverNavBar
-(void)setActivityIndicatorCoverNavBar:(Boolean)activityIndicatorCoverNavBar {
    NSNumber *number = [NSNumber numberWithBool: activityIndicatorCoverNavBar];
    objc_setAssociatedObject(self, ActivityIndicatorCoverKey, number, OBJC_ASSOCIATION_RETAIN);
}
-(Boolean)activityIndicatorCoverNavBar{
    NSNumber *number=objc_getAssociatedObject(self, ActivityIndicatorCoverKey);
    if (number==nil) {
        //default is true
        number=[[NSNumber alloc] initWithBool:true];
    }
    return [number boolValue];
}
@end
