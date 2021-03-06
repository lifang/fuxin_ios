//
//  FXNotificationManageViewController.m
//  FuXin
//
//  Created by lihongliang on 14-6-4.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXNotificationManageViewController.h"
#import "FXNotificationManageTableViewCell.h"
#import "FXNotificationContentViewController.h"

#define kBlankSize 15
@interface FXNotificationManageViewController ()
@property (strong ,nonatomic) UITableView *tableView;
@end

static NSString *cellIdentifier = @"cell";

@implementation FXNotificationManageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setRightNavBarItemWithImageName:@"rubbish.png"];
    [self setLeftNavBarItemWithImageName:@"back.png"];
    [self setTitle:@"系统公告"];
    
    [self initView];
    self.title = @"系统公告";
}

- (void)initView{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITableView *table = [[UITableView alloc] initWithFrame:(CGRect){kBlankSize , kBlankSize ,320 - 2 * kBlankSize ,560} style:UITableViewStylePlain];
    table.dataSource = self;
    table.delegate = self;
    [table registerClass:[FXNotificationManageTableViewCell class] forCellReuseIdentifier:cellIdentifier];
    [self.view addSubview:table];
    table.backgroundColor = [UIColor clearColor];
    if (kDeviceVersion >= 7.0) {
        table.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    table.separatorColor = kColor(211, 211, 211, 1);
    UIView *footer = [[UIView alloc] initWithFrame:CGRectZero];
    table.tableFooterView = footer;
    self.tableView = table;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    CGRect frame = self.view.frame;
    self.tableView.frame = CGRectMake(kBlankSize, kBlankSize, 320 - 2 * kBlankSize, frame.size.height - kBlankSize);
}

- (void)viewDidAppear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"notificationManage"];

}

- (void)viewDidDisappear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"notificationManage"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark TableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
    //retrun self.dataArray.count;
}

- (FXNotificationManageTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FXNotificationManageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    //cell.notificationModel = self.dataArray.count[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FXNotificationContentViewController *contentVC = [[FXNotificationContentViewController alloc] init];
    [self.navigationController pushViewController:contentVC animated:YES];
}

@end
