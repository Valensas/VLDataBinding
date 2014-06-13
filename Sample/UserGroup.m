//
//  UserGroup.m
//  DataBinding
//
//  Created by Can Yaman on 02/04/14.
//  Copyright (c) 2014 Valensas. All rights reserved.
//

#import "UserGroup.h"
#import "User.h"

@implementation UserGroup
+(Class)users_class{
    return [User class];
}
@end
