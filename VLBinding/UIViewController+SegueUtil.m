//
//  UIViewController+SegueUtil.m
//  VLBinding
//
//  Created by Can Yaman on 05/06/14.
//  Copyright (c) 2014 Valensas. All rights reserved.
//

#import "UIViewController+SegueUtil.h"
#import "UIViewController+StoryboardTransition.h"
#import "UITableViewCell+ContentData.h"
#import <objc/runtime.h>

@implementation UIViewController (SegueUtil)
+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL shouldSegue = @selector(shouldPerformSegueWithIdentifier:sender:);
        SEL vl_shouldSegue =  @selector(vl_shouldPerformSegueWithIdentifier:sender:);
        
        SEL prepareSegue = @selector(prepareForSegue:sender:);
        SEL vl_prepareForSegue =  @selector(vl_prepareForSegue:sender:);
        
        Method shouldSegueMethod = class_getInstanceMethod(self, shouldSegue);
        Method vl_shouldSegueMethod = class_getInstanceMethod(self, vl_shouldSegue);
        
        Method prepareSegueMethod = class_getInstanceMethod(self, prepareSegue);
        Method vl_prepareForSegueMethod = class_getInstanceMethod(self, vl_prepareForSegue);
        
        method_exchangeImplementations(shouldSegueMethod, vl_shouldSegueMethod);
        method_exchangeImplementations(prepareSegueMethod, vl_prepareForSegueMethod);
        
    });
}
-(BOOL)vl_shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    static NSString *jumpSuffix=@"Jump";
    //UIViewController+StoryboardTransition.h begin
    if ([identifier hasSuffix:jumpSuffix]) {
        //perform storyboard load and init
        NSString *storyboardNameAndMethod=[identifier substringToIndex:identifier.length-jumpSuffix.length];
        //PushJump,CurlModelJump
        if ([storyboardNameAndMethod hasSuffix:@"Push"]) {
            NSString *storyboardName=[storyboardNameAndMethod substringToIndex:storyboardNameAndMethod.length-@"Push".length];
            [self pushStoryboard:storyboardName];
        }else {
            NSString *storyboardName=storyboardNameAndMethod;
            UIModalTransitionStyle modelStyle=UIModalTransitionStyleCoverVertical;
            if ([storyboardName hasSuffix:@"Cover"]) {
                storyboardName=[storyboardNameAndMethod substringToIndex:storyboardNameAndMethod.length-@"Cover".length];
                modelStyle=UIModalTransitionStyleCoverVertical;
            }else if ([storyboardName hasSuffix:@"Flip"]) {
                storyboardName=[storyboardNameAndMethod substringToIndex:storyboardNameAndMethod.length-@"Flip".length];
                modelStyle=UIModalTransitionStyleFlipHorizontal;
            }else if ([storyboardName hasSuffix:@"Cross"]) {
                storyboardName=[storyboardNameAndMethod substringToIndex:storyboardNameAndMethod.length-@"Cross".length];
                modelStyle=UIModalTransitionStyleCrossDissolve;
            }else if ([storyboardName hasSuffix:@"Curl"]) {
                storyboardName=[storyboardNameAndMethod substringToIndex:storyboardNameAndMethod.length-@"Curl".length];
                modelStyle=UIModalTransitionStylePartialCurl;
            }
            [self transitionToStoryBoard:storyboardName transitionStyle:modelStyle];
        }
        return NO;
    //UIViewController+StoryboardTransition.h end
    }else{
        NSString *selectorName=[NSString stringWithFormat:@"willPerform%@:",identifier];
        SEL segueSelector=NSSelectorFromString(selectorName);
        if ([self respondsToSelector:segueSelector]) {
            IMP imp = [self methodForSelector:segueSelector];
            void (*func)(id, SEL, id) = (void *)imp;
            func(self,segueSelector,sender);
            //sysnchronious operation action
            //[self performSelector:segueSelector withObject:sender];
            return NO;
        }else{
            return [self vl_shouldPerformSegueWithIdentifier:identifier sender:sender];
        }
    }
}

-(void)vl_prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSString *selectorName=[NSString stringWithFormat:@"didPerform%@:sender:",segue.identifier];
    SEL prepareSegueSelector=NSSelectorFromString(selectorName);
    if ([segue.destinationViewController respondsToSelector:@selector(setData:)]) {
        if ([sender respondsToSelector:@selector(contentData)]) {
            [segue.destinationViewController setData:[sender contentData]];
        }
    }
    if ([self respondsToSelector:prepareSegueSelector]) {
        IMP imp = [self methodForSelector:prepareSegueSelector];
        void (*func)(id, SEL, id,id) = (void *)imp;
        func(self,prepareSegueSelector,segue,sender);
        //[self performSelector:prepareSegueSelector withObject:segue withObject:sender];
    }else{
        [self vl_prepareForSegue:segue sender:sender];
    }
}
- (IBAction)dismissWithAnimation:(id)sender{
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}
- (IBAction)dismissWithoutAnimation:(id)sender{
    [self dismissViewControllerAnimated:NO
                             completion:nil];
}
@end
