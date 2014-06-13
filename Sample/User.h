//
//  User.h
//  DataBinding
//
//  Created by Can Yaman on 02/04/14.
//  Copyright (c) 2014 Valensas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Jastor.h"

@interface User : Jastor
@property(nonatomic)NSUInteger uid;
@property(nonatomic)NSString *name;
@property(nonatomic)NSString *email;
@property(nonatomic)NSString *title;
@property(nonatomic)NSString *avatar;
@property(nonatomic)BOOL admin;
@end
