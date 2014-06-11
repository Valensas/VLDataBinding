//
//  UIViewController+SegueUtil.h
//  VLBinding
//
//  Created by Can Yaman on 05/06/14.
//  Copyright (c) 2014 Valensas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (SegueUtil)
- (IBAction)dismissWithAnimation:(id)sender;
- (IBAction)dismissWithoutAnimation:(id)sender;
- (void)vl_prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;
- (BOOL)vl_shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender;
@end
