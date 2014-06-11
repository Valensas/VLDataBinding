//
//  VLMasterViewController.m
//  Sample
//
//  Created by Can Yaman on 09/06/14.
//  Copyright (c) 2014 Valensas. All rights reserved.
//

#import "VLMasterViewController.h"
#import "VLDetailViewController.h"
#import "WaitOperation.h"


@implementation VLMasterViewController

-(void)didPerformWithOpertionSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSLog(@"didPerformWithOpertionSegue");
    UIViewController *destination=(UIViewController *)segue.destinationViewController;
    NSOperation<ObservableOperation> *waitOp=[WaitOperation operaitonWithInterval:2];
    destination.operation=waitOp;
}

-(void)willPerformAfterOperationSegue:(id)sender{
    
    NSLog(@"willPerformAfterOperationSegue");
    NSOperation<ObservableOperation> *waitOp=[WaitOperation operaitonWithInterval:2];
    self.operation=waitOp;
    __weak UIViewController *this=self;
    [waitOp setCompletionBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Finishing: %@",[NSDate date]);
            this.operation=nil;
            [this performSegueWithIdentifier:@"AfterOperationSegue" sender:sender];
            NSLog(@"Finished: %@",[NSDate date]);
        });
    }];
}

@end
