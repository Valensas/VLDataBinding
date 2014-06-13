//
//  ObservableOperation.h
//  Sample
//
//  Created by Can Yaman on 10/06/14.
//  Copyright (c) 2014 Valensas. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, OperationState) {
    OperationPausedState      = -1,
    OperationReadyState       = 1,
    OperationExecutingState   = 2,
    OperationFinishedState    = 3,
};
@protocol ObservableOperation <NSObject>
@property (readwrite, nonatomic, assign) NSInteger state;
@end
