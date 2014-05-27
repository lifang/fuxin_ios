//
//  FXSystemInfoViewController.m
//  FuXin
//
//  Created by SumFlower on 14-5-26.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXSystemInfoViewController.h"
#import "FXSysInfoTableViewCell.h"
#import "FXSysDetailViewController.h"
@interface FXSystemInfoViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation FXSystemInfoViewController

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
    //设置左右button
    UIButton *leftbt = [UIButton buttonWithType:UIButtonTypeCustom];
    leftbt.frame = CGRectMake(0, 0, 32, 32);
    [leftbt addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
    [leftbt setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:leftbt];
    self.navigationItem.leftBarButtonItem = left;
    
    UIButton *rightbt = [UIButton buttonWithType:UIButtonTypeCustom];
    rightbt.frame = CGRectMake(0, 0, 32, 32);
    [rightbt setBackgroundImage:[UIImage imageNamed:@"lj"] forState:UIControlStateNormal];
    [rightbt addTarget:self action:@selector(clearInfo) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:rightbt];
    self.navigationItem.rightBarButtonItem = right;
    
    self.title = @"系统公告管理";
    self.myTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.myTable.dataSource = self;
    self.myTable.delegate = self;
    [self.view addSubview:self.myTable];
    // Do any additional setup after loading the view from its nib.
}
-(void)clearInfo
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否删除公告" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alert show];
}
-(void)backView
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    static BOOL nibRegister = NO;
    if (!nibRegister) {
        UINib *nib = [UINib nibWithNibName:@"FXSysInfoTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    }
    FXSysInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[FXSysInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.newsInfo.image = [UIImage imageNamed:@"new"];
    cell.infoContent.text = @"金讲堂开课啦！挖掘全国（全球）全领域优秀...";
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FXSysDetailViewController *sysdetail = [[FXSysDetailViewController alloc]init];
    [self.navigationController pushViewController:sysdetail animated:YES];
}
@end
