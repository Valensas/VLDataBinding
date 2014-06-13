//
//  ReadFileOperation.h
//  Sample
//
//  Created by Can Yaman on 11/06/14.
//  Copyright (c) 2014 Valensas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReadFileOperation : NSOperation<ObservableOperation>
+(ReadFileOperation *)operaitonWithFile:(NSString *)filename withCompletionBlock:(void (^)(void))completionBlock;
@property(nonatomic,assign)OperationState state;
@property(nonatomic)id data;
@property(nonatomic)NSString *filename;
@end
