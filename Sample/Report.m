//
//  Report.m
//  DataBinding
//
//  Created by Can Yaman on 02/04/14.
//  Copyright (c) 2014 Valensas. All rights reserved.
//

#import "Report.h"

@implementation Report

+(Class)tags_class{
    return [NSString class];
}

+(Class)chapters_class{
    return [Chapter class];
}
-(NSString *)codeName{
    return [NSString stringWithFormat:@"%@-%@",self.name,self.reporter.user.name];
}
@end
