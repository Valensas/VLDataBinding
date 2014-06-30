//
//  VLTableView.m
//  VLBinding
//
//  Created by Can Yaman on 05/06/14.
//  Copyright (c) 2014 Valensas. All rights reserved.
//

#import "VLTableView.h"
#import <objc/runtime.h>

@implementation VLTableView

-(id)data{
    return nil;
}
-(void)setData:(id)data{
    UIViewController *controller=(UIViewController *)self.dataSource;
    if (controller) {
        [controller setValue:data forKey:@"data"];
    }
}
-(NSDictionary *)sectionsData{
    NSMutableDictionary *mutableDict=[NSMutableDictionary dictionary];
    if(self.section0){
        [mutableDict setObject:self.section0 forKey:[NSNumber numberWithInt:0]];
    }
    if(self.section1){
        [mutableDict setObject:self.section1 forKey:[NSNumber numberWithInt:1]];
    }
    if(self.section2){
        [mutableDict setObject:self.section2 forKey:[NSNumber numberWithInt:2]];
    }
    if(self.section3){
        [mutableDict setObject:self.section3 forKey:[NSNumber numberWithInt:3]];
    }
    if(self.section4){
        [mutableDict setObject:self.section4 forKey:[NSNumber numberWithInt:4]];
    }
    if(self.section5){
        [mutableDict setObject:self.section5 forKey:[NSNumber numberWithInt:5]];
    }
    if(self.section6){
        [mutableDict setObject:self.section6 forKey:[NSNumber numberWithInt:6]];
    }
    if(self.section7){
        [mutableDict setObject:self.section7 forKey:[NSNumber numberWithInt:7]];
    }
    if(self.section8){
        [mutableDict setObject:self.section8 forKey:[NSNumber numberWithInt:8]];
    }
    if(self.section9){
        [mutableDict setObject:self.section9 forKey:[NSNumber numberWithInt:9]];
    }
    if(self.section10){
        [mutableDict setObject:self.section10 forKey:[NSNumber numberWithInt:10]];
    }
    return mutableDict;
}
@end
