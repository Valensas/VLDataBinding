//
//  VLTableViewController.m
//  VLBinding
//
//  Created by Can Yaman on 05/06/14.
//  Copyright (c) 2014 Valensas. All rights reserved.
//

#import "VLTableViewController.h"
#import "UIViewController+Data.h"
#import "UIView+PropertyBinding.h"
#import "UITableViewCell+ContentData.h"
#import "VLTableViewCell.h"
#import "VLTableView.h"

@implementation VLTableViewController

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=nil;
    if ([self isDynamicCell:indexPath]) {
        UITableViewCell *sectionPrototypeCell=[self tableView:tableView prototypeCellForIndexPath:indexPath];
        NSString *cellIdentifier=sectionPrototypeCell.reuseIdentifier;
        if (!cellIdentifier) {
            cellIdentifier=@"Cell";
        }
        NSArray *sectionArray=[self tableDataOfSection:[indexPath section]];
        if ((sectionArray.count==0)&&(self.data)&&(indexPath.row==0)) {
            cellIdentifier=@"NoDataCell";
            cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            return cell;
        }
        cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        //if not reused
        if (cell.contentView.subviews.count==0) {
            //clone prototype cell
            cell=[sectionPrototypeCell cloneView];
        }
        id cellData=[self cellDataForIndexPath:indexPath];
        [cell bindWithObject:cellData];
        cell.contentData=cellData;
    }else{
        cell=[super tableView:tableView cellForRowAtIndexPath:indexPath];
        [cell bindWithObject:self.data];
    }
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numOfRow=0;
    NSArray *sectionData=[self tableDataOfSection:section];
    if (!sectionData) {
        //static cell section of NSArray data type
        numOfRow = [super tableView:self.tableView numberOfRowsInSection:section];
    }else{
        //dynamic cell section
        numOfRow = sectionData.count;
        if ((numOfRow==0)&&(self.data)&&([tableView dequeueReusableCellWithIdentifier:@"NoDataCell"])){
            numOfRow=1;
        }
    }
    return numOfRow;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self isDynamicCell:indexPath]) {
        NSIndexPath *genericIndexPath=[NSIndexPath indexPathForRow:0 inSection:indexPath.section];
        return [super tableView:tableView heightForRowAtIndexPath:genericIndexPath];
    }else{
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}
-(NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self isDynamicCell:indexPath]) {
        NSIndexPath *genericIndexPath=[NSIndexPath indexPathForRow:0 inSection:indexPath.section];
        return [super tableView:tableView indentationLevelForRowAtIndexPath:genericIndexPath];
    }else{
        return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSArray *segues=[self getInstanceVariable:self name:@"_storyboardSegueTemplates"];
    //    NSDictionary *externals=[self getInstanceVariable:self name:@"_externalObjectsTableForViewLoading"];
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    
    //    for (UIView *view in [c subviews]) {
    //        if ([view isKindOfClass:[UITextField class]]) {
    //            UITextField *textView=(UITextField *)view;
    //            if (textView) {
    //                [textView becomeFirstResponder];
    //            }
    //            break;
    //
    //        }
    //    }
    self.selectedCell=cell;
    self.selectedIndex=indexPath;
    [cell setSelected:FALSE];
    //
    
    UITextField *textField=[self textFieldOfParentView:cell];
    if (textField) {
        [textField becomeFirstResponder];
        [tableView scrollToRowAtIndexPath:indexPath
                         atScrollPosition:UITableViewScrollPositionTop
                                 animated:YES];
    }else{
        [self.view endEditing:YES];
        
    }
    if ([cell isKindOfClass:[VLTableViewCell class]]) {
        VLTableViewCell *vlCell=(VLTableViewCell *)cell;
        if (vlCell.segueIdentifier) {
            if ([self shouldPerformSegueWithIdentifier:vlCell.segueIdentifier sender:cell]) {
                [self  performSegueWithIdentifier:vlCell.segueIdentifier sender:cell];
            }
        }
    }
    
}
-(UITextField *)textFieldOfParentView:(UIView *)parentView{
    for (UIView *view in [parentView subviews]) {
        if ([view isKindOfClass:[UITextField class]]) {
            return (UITextField *)view;
        }else{
            UITextField *result=[self textFieldOfParentView:view];
            if (result) {
                return result;
            }
        }
    }
    return nil;
}
-(void)textFieldBecomeFirstReponder:(UIView *)parentView{
    UIView *text=[self textFieldOfParentView:parentView];
    if (text) {
        [text becomeFirstResponder];
    }
}
-(BOOL)parentView:(UIView *)parentView containsView:(UIView *)childView{
    for (UIView *view in [parentView subviews]) {
        if (view == childView) {
            return YES;
        }else{
            if([self parentView:view containsView:childView]){
                return YES;
            }
        }
    }
    return NO;
}
-(UITableViewCell *)parentCell:(UIView *)view{
    if ([view superview]) {
        if ([view.superview isKindOfClass:[UITableViewCell class]]) {
            return (UITableViewCell *)view.superview;
        }else{
            return [self parentCell:view.superview];
        }
    }
    return nil;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (self.selectedCell) {
        if(![self parentView:self.selectedCell containsView:textField]){
            self.selectedCell=[self parentCell:textField];
            self.selectedIndex=[self.tableView indexPathForCell:self.selectedCell];
        }
    }else{
        self.selectedCell=[self parentCell:textField];
        self.selectedIndex=[self.tableView indexPathForCell:self.selectedCell];
    }
    [self.tableView scrollToRowAtIndexPath:self.selectedIndex
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:YES];
    return YES;
}      // called when clear button pressed. return NO to ignore (no notifications)
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSIndexPath *nextIndexPath=nil;
    if (self.selectedIndex) {
        if ([self tableView:self.tableView numberOfRowsInSection:self.selectedIndex.section] > self.selectedIndex.row+1) {
            nextIndexPath=[NSIndexPath indexPathForRow:self.selectedIndex.row+1 inSection:self.selectedIndex.section];
            [self tableView:self.tableView didSelectRowAtIndexPath:nextIndexPath];
            
        } else if (([self numberOfSectionsInTableView:self.tableView]>self.selectedIndex.section+1)
                   &&[self tableView:self.tableView numberOfRowsInSection:self.selectedIndex.section+1] > 0){
            nextIndexPath=[NSIndexPath indexPathForRow:0 inSection:self.selectedIndex.section+1];
            [self tableView:self.tableView didSelectRowAtIndexPath:nextIndexPath];
            
        }
    }
    
    return YES;
}
-(void)setData:(id)data{
    super.data=data;
    
    //if static table view
    //    if (![self respondsToSelector:@selector(tableView:cellForRowAtIndexPath:)]) {
    //        for ( UIView *subview in [self.tableView subviews] ) {
    //            [subview bindWithObject:data];
    //        }
    //    }
    if ([data isKindOfClass:[NSArray class]]) {
        //This is dynamic simple 1 section table view
        self.sectionsKeyPath=[NSMutableDictionary dictionaryWithObject:@"self" forKey:[NSNumber numberWithInteger:0]];
    }else{
        if ([self.tableView isKindOfClass:[VLTableView class]]) {
            self.sectionsKeyPath=[(VLTableView *)self.tableView sectionsData];
        }
    }
    [self.tableView reloadData];
    [self.tableView layoutIfNeeded];
}
-(BOOL)isDynamicCell:(NSIndexPath *)indexPath{
    if ([self.sectionsKeyPath objectForKey:[NSNumber numberWithInteger:indexPath.section]]) {
        return YES;
    }
    return NO;
}

-(UITableViewCell *)tableView:(UITableView *)tableView prototypeCellForIndexPath:(NSIndexPath *)indexPath {
    return [super tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]];
}
-(void)tableView:(UITableView *)tableView registerPrototypeCellAtSection:(NSInteger)section{
    UITableViewCell *sectionPrototypeCell=[self tableView:tableView prototypeCellForIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    [tableView registerClass:[sectionPrototypeCell class] forCellReuseIdentifier:sectionPrototypeCell.reuseIdentifier];
}
-(NSArray *)tableDataOfSection:(NSInteger)section{
    NSString *sectionKeyPath= [self.sectionsKeyPath objectForKey:[NSNumber numberWithInteger:section]];
    if (sectionKeyPath) {
        NSArray *array=[self.data valueForKeyPath:sectionKeyPath];
        if (array) {
            return  array;
        }else{
            return [NSArray array];
        }
    }
    return nil;
}
-(id)cellDataForIndexPath:(NSIndexPath *)indexPath{
    NSArray *sectionArray=[self tableDataOfSection:[indexPath section]];
    if (sectionArray) {
        return [sectionArray objectAtIndex:indexPath.row];
    }else{
        return sectionArray;
    }
}

@end
