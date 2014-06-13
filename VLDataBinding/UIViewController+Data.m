//
//  UIViewController+Data.m
//  VLBinding
//
//  Created by Can Yaman on 05/06/14.
//  Copyright (c) 2014 Valensas. All rights reserved.
//

#import "UIViewController+Data.h"
#import "VLTableViewController.h"
#import <objc/runtime.h>

static void * const DataKey = (void*)&DataKey;

@implementation UIViewController (Data)

-(void)setData:(id)data{
    if ([self isKindOfClass:[VLTableViewController class]]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            ((VLTableViewController *)self).tableData=data;
        });
    }
    objc_setAssociatedObject(self, DataKey, data, OBJC_ASSOCIATION_RETAIN);
}
-(id)data{
    return objc_getAssociatedObject(self, DataKey);
}

@end
