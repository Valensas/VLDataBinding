//
//  ReadFileOperation.m
//  Sample
//
//  Created by Can Yaman on 11/06/14.
//  Copyright (c) 2014 Valensas. All rights reserved.
//

#import "ReadFileOperation.h"

@implementation ReadFileOperation
+(ReadFileOperation *)operaitonWithFile:(NSString *)filename
                    withCompletionBlock:(void (^)(void))completionBlock{
    static NSOperationQueue *readQueue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        readQueue=[[NSOperationQueue alloc] init];
    });
    ReadFileOperation *operation=[[ReadFileOperation alloc] init];
    operation.state=OperationPausedState;
    operation.filename=filename;
    
    [operation setCompletionBlock:completionBlock];
    [readQueue addOperation:operation];
    return operation;
}
-(void)main{
    NSLog(@"Reading File: %@",[NSDate date]);
    self.state=OperationExecutingState;
    [NSThread sleepForTimeInterval:3.0];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:self.filename ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    self.data=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSLog(@"Read File: %@",[NSDate date]);
}
@end
