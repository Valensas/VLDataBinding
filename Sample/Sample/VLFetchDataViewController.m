//
//  VLFetchDataViewController.m
//  Sample
//
//  Created by Can Yaman on 11/06/14.
//  Copyright (c) 2014 Valensas. All rights reserved.
//

#import "VLFetchDataViewController.h"
#import "ReadFileOperation.h"
#import "Report.h"

@interface VLFetchDataViewController ()

@end

@implementation VLFetchDataViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    __weak VLFetchDataViewController *this=self;
    self.operation=[ReadFileOperation operaitonWithFile:@"reports" withCompletionBlock:^{
        NSMutableArray *reports=[NSMutableArray array];
        for (NSDictionary *reportDict in ((ReadFileOperation*)this.operation).data) {
            [reports addObject:[Report objectFromDictionary:reportDict]];
        }
        this.data=reports;
        [this.operation willChangeValueForKey:@"state"];
        this.operation.state=OperationFinishedState;
        [this.operation didChangeValueForKey:@"state"];
    }];
    [super viewWillAppear:animated];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
