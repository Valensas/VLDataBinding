//
//  ActivityIndicatorView.m
//  VLBinding
//
//  Created by Can Yaman on 05/06/14.
//  Copyright (c) 2014 Valensas. All rights reserved.
//

#import "ActivityIndicatorView.h"
#define INDICATOR_TIMEOUT_INTERVAL 30.0

static void *operationIsFinished = &operationIsFinished;

@implementation ActivityIndicatorView
-(void)setLabel:(NSString *)label{
    _label=label;
    if (self.activityView) {
        [DejalActivityView currentActivityView].activityLabel.text = label;
    }
}
-(void)setActivityView:(DejalActivityView *)activityView{
    _activityView=activityView;
    //register
}
-(id)initWithOperation:(NSOperation<ObservableOperation> *)operation viewToUse:(UIView *)view{
    self=[self initWithOperation:operation viewToUse:view label:NSLocalizedString(@"Loading...", @"Default ActivtyView label text")];
    return self;
}
-(id)initWithOperation:(NSOperation<ObservableOperation> *)operation viewToUse:(UIView *)view label:(NSString *)label{
    self=[super init];
    if (self) {
        if (label) {
            self.activityView=[DejalBezelActivityView activityViewForView:view withLabel:label];
        }else{
            self.activityView=[DejalBezelActivityView activityViewForView:view];
        }
        [DejalActivityView currentActivityView].showNetworkActivityIndicator = YES;
        self.timeoutTimer=[NSTimer timerWithTimeInterval:INDICATOR_TIMEOUT_INTERVAL target:self selector:@selector(activityViewTimeout:) userInfo:nil repeats:FALSE];
        [[NSRunLoop mainRunLoop] addTimer:self.timeoutTimer forMode:NSRunLoopCommonModes];
        if (self.operation) {
            [self.operation removeObserver:self forKeyPath:@"state"];
        }
        self.operation=operation;
        if (operation) {
            [operation addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:operationIsFinished];
            if (operation.isFinished) {
                [self observeValueForKeyPath:@"state" ofObject:operation change:nil context:operationIsFinished];
            }
        }
    }
    return self;
}
- (void)activityViewTimeout:(NSTimer *)timer{
    [self.operation removeObserver:self forKeyPath:@"state"];
    self.operation=nil;
    [self performSelectorOnMainThread:@selector(removeActivityViewWithAnimation:) withObject:[[NSNumber alloc] initWithBool:NO] waitUntilDone:NO];
}
- (void)removeActivityViewWithAnimation:(BOOL)animation;
{
    // Remove the activity view, with animation for the two styles that support it:
    [DejalActivityView currentActivityView].showNetworkActivityIndicator = NO;
    [DejalBezelActivityView removeViewAnimated:animation];
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
    if (self.timeoutTimer) {
        [self.timeoutTimer invalidate];
    }
    self.activityView=nil;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (context == operationIsFinished) {
        NSOperation *op=object;
        if(op.isFinished){
            //[self removeActivityViewWithAnimation:NO];
            [self.operation removeObserver:self forKeyPath:@"state"];
            self.operation=nil;
            [self performSelectorOnMainThread:@selector(removeActivityViewWithAnimation:) withObject:[[NSNumber alloc] initWithBool:YES] waitUntilDone:YES];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
-(void)dealloc{
    if (self.operation) {
        [self.operation removeObserver:self forKeyPath:@"state"];
        self.operation=nil;
    }
}
@end