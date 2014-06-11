//
//  VLTableView.h
//  VLBinding
//
//  Created by Can Yaman on 05/06/14.
//  Copyright (c) 2014 Valensas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VLTableView : UITableView
@property(nonatomic)NSString* section0;
@property(nonatomic)NSString* section1;
@property(nonatomic)NSString* section2;
@property(nonatomic)NSString* section3;
@property(nonatomic)NSString* section4;
@property(nonatomic)NSString* section5;
@property(nonatomic)NSString* section6;
@property(nonatomic)NSString* section7;
@property(nonatomic)NSString* section8;
@property(nonatomic)NSString* section9;
@property(nonatomic)NSString* section10;
@property(nonatomic,readonly)NSDictionary* sectionsData;
@property(nonatomic,weak)id data;
@property(nonatomic)BOOL headerShown;
@end
