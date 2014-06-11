//
//  UITableViewCell+ContentData.m
//  VLBinding
//
//  Created by Can Yaman on 05/06/14.
//  Copyright (c) 2014 Valensas. All rights reserved.
//

#import "UITableViewCell+ContentData.h"
#import <objc/runtime.h>

static void * const ContentDataKey = (void*)&ContentDataKey;

@implementation UITableViewCell (ContentData)

-(void)setContentData:(id)contentData{
    objc_setAssociatedObject(self, ContentDataKey, contentData, OBJC_ASSOCIATION_RETAIN);
}
-(id)contentData{
    return objc_getAssociatedObject(self, ContentDataKey);
}
@end
