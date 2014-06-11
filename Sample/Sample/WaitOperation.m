//
//  WaitOperation.m
//  DataBinding
//
//  Created by Can Yaman on 02/04/14.
//  Copyright (c) 2014 Valensas. All rights reserved.
//

#import "WaitOperation.h"

@implementation WaitOperation
+(WaitOperation *)operaitonWithInterval:(NSUInteger)interval{
    static NSOperationQueue *waitQueue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        waitQueue=[[NSOperationQueue alloc] init];
    });
    WaitOperation *operation=[[WaitOperation alloc] init];
    operation.state=OperationPausedState;
    operation.interval=interval;
    
    __weak WaitOperation *weakOp=operation;
    [operation setCompletionBlock:^{
        NSLog(@"Finished: %@",[NSDate date]);
        weakOp.state=OperationFinishedState;
    }];
    [waitQueue addOperation:operation];
    return operation;
}
-(void)main{
//    self.state=OperationReadyState;
    self.state=OperationExecutingState;
    NSLog(@"Waiting... %@",[NSDate date]);
    [NSThread sleepForTimeInterval:self.interval];
    NSLog(@"Excuted: %@",[NSDate date]);
}
@end
