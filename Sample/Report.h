//
//  Report.h
//  DataBinding
//
//  Created by Can Yaman on 02/04/14.
//  Copyright (c) 2014 Valensas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reporter.h"
#import "Chapter.h"
#import "UserGroup.h"

@interface Report : Jastor
@property(nonatomic)NSString *name;
@property(nonatomic)Reporter *reporter;
@property(nonatomic)NSString *description;
@property(nonatomic)NSArray *tags;
@property(nonatomic)NSNumber *rating;
@property(nonatomic)NSArray *chapters;
@property(nonatomic)UserGroup *subscribedUsers;
@property(nonatomic,readonly)NSString *codeName;
@end
