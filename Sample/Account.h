//
//  Account.h
//  DataBinding
//
//  Created by Can Yaman on 02/04/14.
//  Copyright (c) 2014 Valensas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Jastor.h"

//Detail of the user

@interface Account : Jastor
@property(nonatomic) NSString *userId;
@property(nonatomic) NSDate *createDate;
@property(nonatomic) NSArray *accessLogs;
@property(nonatomic) NSArray *reports;
@property(nonatomic) NSArray *favorites;
@end
