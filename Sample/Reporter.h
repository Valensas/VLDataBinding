//
//  Reporter.h
//  DataBinding
//
//  Created by Can Yaman on 02/04/14.
//  Copyright (c) 2014 Valensas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Jastor.h"

@interface Reporter : Jastor
@property(nonatomic)User *user;
@property(nonatomic)NSString *signature;
@property(nonatomic)NSString *company;
@property(nonatomic)NSString *homePage;
@end
