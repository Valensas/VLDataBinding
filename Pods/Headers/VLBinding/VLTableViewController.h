//
//  VLTableViewController.h
//  VLBinding
//
//  Created by Can Yaman on 05/06/14.
//  Copyright (c) 2014 Valensas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VLTableViewController : UITableViewController
@property (nonatomic) UITableViewCell *selectedCell;
@property (nonatomic) NSIndexPath *selectedIndex;
@property (nonatomic) NSDictionary *sectionsKeyPath;
@end
