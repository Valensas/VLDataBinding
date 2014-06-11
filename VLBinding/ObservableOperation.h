//
//  ObservableOperation.h
//  Sample
//
//  Created by Can Yaman on 10/06/14.
//  Copyright (c) 2014 Valensas. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ObservableOperation <NSObject>
@property (readwrite, nonatomic, assign) NSInteger state;
@end
