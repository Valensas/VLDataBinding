//
//  ActivityIndicatorView.h
//  VLBinding
//
//  Created by Can Yaman on 05/06/14.
//  Copyright (c) 2014 Valensas. All rights reserved.
//

#import "DejalActivityView.h"
#import "ObservableOperation.h"

@interface ActivityIndicatorView : NSObject
@property(nonatomic)DejalActivityView *activityView;
@property(atomic)NSOperation<ObservableOperation> *operation;
@property(atomic)NSTimer *timeoutTimer;
@property(nonatomic)NSString *label;
@property(nonatomic,weak)UIView *viewToUse;
-(id)initWithOperation:(NSOperation<ObservableOperation> *)operation viewToUse:(UIView *)view;
-(id)initWithOperation:(NSOperation<ObservableOperation> *)operation viewToUse:(UIView *)view label:(NSString *)label;
-(void)removeActivityViewWithAnimation:(BOOL)animation;
@end
