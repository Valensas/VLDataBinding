//
//  UIView+PropertyBinding.h
//  VLBinding
//
//  Created by Can Yaman on 05/06/14.
//  Copyright (c) 2014 Valensas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (PropertyBinding)
-(instancetype)cloneView;
-(void)bindWithObject:(id)obj;
@end
