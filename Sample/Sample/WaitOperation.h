//
//  WaitOperation.h
//  DataBinding
//
//  Created by Can Yaman on 02/04/14.
//  Copyright (c) 2014 Valensas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObservableOperation.h"

typedef NS_ENUM(NSInteger,OperationState) {
    OperationPausedState      = -1,
    OperationReadyState       = 1,
    OperationExecutingState   = 2,
    OperationFinishedState    = 3,
};

@interface WaitOperation : NSOperation <ObservableOperation>
@property(nonatomic)NSUInteger interval;
+(WaitOperation *)operaitonWithInterval:(NSUInteger)interval;
@property(nonatomic,assign)OperationState state;
@end
