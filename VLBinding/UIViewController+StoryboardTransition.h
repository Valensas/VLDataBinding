//
//  UIViewController+UIViewController_StoryboardTransition.h
//  VLBinding
//
//  Created by Can Yaman on 05/06/14.
//  Copyright (c) 2014 Valensas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (StoryboardTransition)
-(void)pushStoryboard:(NSString *)storyboardName;
-(void)transitionToStoryBoard:(NSString *)storyboardName transitionStyle:(UIModalTransitionStyle)modelStyle;
-(void)transitionToStoryBoard:(NSString *)storyboardName transitionStyle:(UIModalTransitionStyle)transitionStyle presentationStyle:(UIModalPresentationStyle)presentationStyle;
@end
