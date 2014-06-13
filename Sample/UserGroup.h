//
//  UserGroup.h
//  DataBinding
//
//  Created by Can Yaman on 02/04/14.
//  Copyright (c) 2014 Valensas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Jastor.h"

@interface UserGroup : Jastor
@property(nonatomic)NSString* name;
@property(nonatomic)NSString* description;
@property(nonatomic)NSArray* users;
@end
