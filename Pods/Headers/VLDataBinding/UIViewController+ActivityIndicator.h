//
//  UIViewController+ActivityIndicator.h
//  VLBinding
//
//  Created by Can Yaman on 05/06/14.
//  Copyright (c) 2014 Valensas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObservableOperation.h"
@class ActivityIndicatorView;
@interface UIViewController (ActivityIndicator)
@property(atomic)ActivityIndicatorView *activityIndicatorView;
@property(atomic)NSOperation<ObservableOperation> *operation;
@property(nonatomic)NSString *activityIndicatorLabel;
@property(nonatomic)Boolean activityIndicatorCoverNavBar;
-(void)removeActivityViewWithAnimation:(BOOL)animation;
-(IBAction)displayActivityView:(NSString *)label;
@end
