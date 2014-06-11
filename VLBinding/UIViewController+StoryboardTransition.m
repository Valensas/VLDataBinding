//
//  UIViewController+UIViewController_StoryboardTransition.m
//  VLBinding
//
//  Created by Can Yaman on 05/06/14.
//  Copyright (c) 2014 Valensas. All rights reserved.
//

#import "UIViewController+StoryboardTransition.h"

@implementation UIViewController (StoryboardTransition)
-(void)transitionToStoryBoard:(NSString *)storyboardName transitionStyle:(UIModalTransitionStyle)modelStyle{
    UIStoryboard *nextStoryboard=[UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]];
    UIViewController *destinationViewController=[nextStoryboard instantiateInitialViewController];
    destinationViewController.modalTransitionStyle=modelStyle;
    [self presentViewController:destinationViewController animated:YES completion:nil];
}
-(void)transitionToStoryBoard:(NSString *)storyboardName transitionStyle:(UIModalTransitionStyle)transitionStyle presentationStyle:(UIModalPresentationStyle)presentationStyle{
    UIStoryboard *nextStoryboard=[UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]];
    UIViewController *destinationViewController=[nextStoryboard instantiateInitialViewController];
    destinationViewController.modalTransitionStyle=transitionStyle;
    destinationViewController.modalPresentationStyle=presentationStyle;
    [self presentViewController:destinationViewController animated:YES completion:nil];
}
-(void)pushStoryboard:(NSString *)storyboardName{
    UIStoryboard *nextStoryboard=[UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]];
    UIViewController *destinationViewController=[nextStoryboard instantiateInitialViewController];
    [self.navigationController pushViewController:destinationViewController animated:YES];
}
@end
