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
#import "VLTableView.h"
#import <objc/runtime.h>

@interface VLTableViewController()
@property(nonatomic)NSMutableDictionary* prototypeCells;
@end
@implementation VLTableViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    if ([self.tableView isKindOfClass:[VLTableView class]]) {
        self.sectionsKeyPath=[(VLTableView *)self.tableView sectionsData];
        //load dynamic section cells
        self.prototypeCells=[NSMutableDictionary dictionary];
        for (NSNumber *section in self.sectionsKeyPath.allKeys) {
            NSInteger numberOfRow=[super tableView:self.tableView numberOfRowsInSection:[section integerValue]];
            for (int i=0; i<numberOfRow; i++) {
                UITableViewCell *cell=[super tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:i inSection:[section integerValue]]];
                NSString *cellReuseIdentifier;
                if (!cell.reuseIdentifier) {
                    cellReuseIdentifier=[NSString stringWithFormat:@"Cell%d",[section intValue]];
                }else{
                    cellReuseIdentifier=cell.reuseIdentifier;
                }
                [self.prototypeCells setObject:cell forKey:cellReuseIdentifier];
                /*
                id s=[cell valueForKey:@"selection"];
                NSLog(@"s %@",s);
                Class elem = [cell class];
                while (elem) {
                    NSLog(@"%s", class_getName( elem ));
                    unsigned int numMethods = 0;
                    Method *mList = class_copyMethodList(elem, &numMethods);
                    if (mList) {
                        for (int j=0; j < numMethods; j++) {
                            NSLog(@"%s %s",class_getName( elem ),
                                  sel_getName(method_getName(mList[j])));
                        }
                        free(mList);
                    }
                    if (elem == [NSObject class]) {
                        break;
                    }
                    elem = class_getSuperclass(elem);
                }*/
                DDLogVerbose(@"VLTableView register cell identifier:%@ index:%d-%d",cell.reuseIdentifier,[section intValue],i);
            }
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=nil;
        if ([self isLoadingSection:indexPath.section]) {
            cell=[self tableView:tableView loadingCellForSection:indexPath.section];
        }else{
            NSArray *sectionArray=[self tableDataOfSection:[indexPath section]];
            if ((sectionArray.count==0)&&(self.tableData)&&(indexPath.row==0)) {
                cell=[self tableView:tableView noDataCellForSection:indexPath.section];
            }else{
                if ([self isDynamicCell:indexPath]) {
                    cell=[self tableView:tableView contentCellForSection:indexPath.section];
                    id cellData=[self cellDataForIndexPath:indexPath];
                    [cell bindWithObject:cellData];
                    cell.contentData=cellData;
                }else{
                    cell=[super tableView:tableView cellForRowAtIndexPath:indexPath];
                    [cell bindWithObject:self.tableData];
                }
            }
        }
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numOfRow=0;
    if ([self isStaticSection:section]) {
        numOfRow = [super tableView:self.tableView numberOfRowsInSection:section];
    }else{
        if ([self isLoadingSection:section]) {
            if ([self tableView:tableView loadingCellForSection:section]) {
                numOfRow=1;
            }else{
                numOfRow=0;
            }
        }else{
            NSArray *sectionData=[self tableDataOfSection:section];
            if (!sectionData) {
                numOfRow=0;
            }else{
                numOfRow=sectionData.count;
            }
            //NoDataCell show if numberOfRow is 0
            if ((numOfRow==0)&&[self tableView:tableView noDataCellForSection:section]) {
                //NoDataCell
                numOfRow=1;
            }
        }
    }
    DDLogVerbose(@"NumberOfRow:%d",(int)numOfRow);
    return numOfRow;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self isDynamicCell:indexPath]) {
        CGFloat height=0;
        if ([self isLoadingSection:indexPath.section]) {
            //Loading Cell
            height=[self tableView:tableView loadingCellForSection:indexPath.section].frame.size.height;
        }else if(!self.tableData){
            //No Data Cell
            height=[self tableView:tableView noDataCellForSection:indexPath.section].frame.size.height;
        }else{
            NSIndexPath *genericIndexPath=[NSIndexPath indexPathForRow:0 inSection:indexPath.section];
            UITableViewCell *dataCell=[self tableView:tableView dynamicTableViewCellForSection:indexPath.section];
            if (dataCell) {
               height=dataCell.frame.size.height;
            }else{
                height=[super tableView:tableView heightForRowAtIndexPath:genericIndexPath];
            }
        }
        return height;
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
    /*
    if ([cell isKindOfClass:[VLTableViewCell class]]) {
        VLTableViewCell *vlCell=(VLTableViewCell *)cell;
        if (vlCell.segueIdentifier) {
            if ([self shouldPerformSegueWithIdentifier:vlCell.segueIdentifier sender:cell]) {
                [self  performSegueWithIdentifier:vlCell.segueIdentifier sender:cell];
            }
        }
    }*/
    
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
-(void)setTableData:(id)data{
    _tableData=data;    
    //if static table view
    //    if (![self respondsToSelector:@selector(tableView:cellForRowAtIndexPath:)]) {
    //        for ( UIView *subview in [self.tableView subviews] ) {
    //            [subview bindWithObject:data];
    //        }
    //    }
    if ([data isKindOfClass:[NSArray class]]&&((self.sectionsKeyPath==nil)||(self.sectionsKeyPath.count==0))) {
        //This is dynamic simple 1 section table view
        self.sectionsKeyPath=[NSMutableDictionary dictionaryWithObject:@"self" forKey:[NSNumber numberWithInteger:0]];
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

-(UITableViewCell *)tableView:(UITableView *)tableView prototypeCellForSection:(NSInteger)section {
    return [super tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
}
-(void)tableView:(UITableView *)tableView registerPrototypeCellAtSection:(NSInteger)section{
    UITableViewCell *sectionPrototypeCell=[self tableView:tableView prototypeCellForSection:section];
    [tableView registerClass:[sectionPrototypeCell class] forCellReuseIdentifier:sectionPrototypeCell.reuseIdentifier];
}
-(NSArray *)tableDataOfSection:(NSInteger)section{
    NSString *sectionKeyPath= [self.sectionsKeyPath objectForKey:[NSNumber numberWithInteger:section]];
    if (sectionKeyPath) {
        NSArray *array=[self.tableData valueForKeyPath:sectionKeyPath];
        if (self.tableData&&(!array)) {
            //data exist and keyPath isEmpty
            return [NSArray array];
        }else{
            //data not exist yet return nil
            //array is not empty return array
            return  array;
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
-(BOOL)isStaticSection:(NSInteger)section{
    DDLogVerbose(@"isStaticSection:%d",(int)section);
    if ([self.tableView isKindOfClass:[VLTableView class]]) {
        return ![self.sectionsKeyPath.allKeys containsObject:[NSNumber numberWithInteger:section]];
    }else{
        return false;
    }
}
-(BOOL)isLoadingSection:(NSInteger)section{
    DDLogVerbose(@"isLoadingSection:%d",(int)section);
    if (self.tableData||[self isStaticSection:section]) {
        return false;
    }else{
        return true;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView noDataCellForSection:(NSInteger)section{
    
    UITableViewCell *noDataCell=[self.prototypeCells objectForKey:[NSString stringWithFormat:@"Section%dNoDataCell",(int)section]];
    if (!noDataCell) {
        noDataCell = [self.prototypeCells objectForKey:@"NoDataCell"];
    }
    if (noDataCell) {
        return [noDataCell cloneView];
    }else{
        return [self tableView:tableView dynamicNoDataCellForSection:section];
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView loadingCellForSection:(NSInteger)section{
    UITableViewCell *loadingCell=[self.prototypeCells objectForKey:[NSString stringWithFormat:@"Section%dLoadingCell",(int)section]];
    if (!loadingCell) {
        loadingCell = [self.prototypeCells objectForKey:@"LoadingCell"];
    }
    if (loadingCell) {
        return [loadingCell cloneView];
    }else{
        return [self tableView:tableView dynamicLoadingCellForSection:section];
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView contentCellForSection:(NSInteger)section{
    UITableViewCell *sectionPrototypeCell=[self tableView:tableView prototypeCellForSection:section];
    NSString *cellIdentifier=sectionPrototypeCell.reuseIdentifier;
    if (!cellIdentifier) {
        cellIdentifier=[NSString stringWithFormat:@"Cell%d",(int)section];;
    }
    sectionPrototypeCell=[self.prototypeCells objectForKey:cellIdentifier];
    if (sectionPrototypeCell) {
        return [sectionPrototypeCell cloneView];
    }else{
        return [self tableView:tableView dynamicTableViewCellForSection:section];
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView dynamicTableViewCellForSection:(NSInteger)section{
    NSString  *cellIdentifier=@"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cellIdentifier=[NSString stringWithFormat:@"Cell%d",(int)section];
        cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    return cell;
}
-(UITableViewCell *)tableView:(UITableView *)tableView dynamicLoadingCellForSection:(NSInteger)section{
    NSString  *cellIdentifier=@"LoadingCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cellIdentifier=[NSString stringWithFormat:@"Section%dLoadingCell",(int)section];
        cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    return cell;
}
-(UITableViewCell *)tableView:(UITableView *)tableView dynamicNoDataCellForSection:(NSInteger)section{
    NSString  *cellIdentifier=@"NoDataCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cellIdentifier=[NSString stringWithFormat:@"Section%dNoDataCell",(int)section];
        cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    return cell;
}
@end
