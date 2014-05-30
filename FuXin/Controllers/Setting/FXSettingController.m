//
//  FXSettingController.m
//  FuXin
//
//  Created by 徐宝桥 on 14-5-20.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXSettingController.h"
#import "FXSettingTableViewCell.h"
#import "FXTuiSongViewController.h"
#import "FXXiuGaiMiMaViewController.h"
#import "FXPingBiGuanLiViewController.h"
#import "FXSystemInfoViewController.h"
#import "FXMyInfoViewController.h"
#import "FXTableViewSheZhiCell.h"


@interface FXSettingController ()

@end

@implementation FXSettingController

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
    self.title = @"设置";
    NSLog(@"%@",self.title);
    self.setTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    [self.view addSubview:self.setTable];
    self.setTable.delegate = self;
    self.setTable.dataSource = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger cellCount;
    if (section == 0) {
        cellCount = 1;
    }else if(section ==1){
        cellCount = 5;
    }else if(section == 2){
        cellCount = 1;
    }else if(section == 3){
        cellCount = 1;
    }
    return cellCount;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (0 == indexPath.section) {
        static BOOL nibsRegister = NO;
        static NSString *ID = @"id";
        if (!nibsRegister) {
            UINib *nib = [UINib nibWithNibName:@"FXSettingTableViewCell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:ID];
            nibsRegister = YES;
        }
        FXSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[FXSettingTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        [cell initCellImage];
        [cell setNeedsLayout];
        return cell;
    }
    
    if (3 == indexPath.section) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.text = @"退出登录";
        cell.imageView.image = [UIImage imageNamed:@"push_icon"];
        [self hiddenExtraCellLine];
        return cell;
    }
    
    if (1 == indexPath.section) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
   if (indexPath.row == 0) {
            cell.imageView.image = [UIImage imageNamed:@"refresh.png"];
            cell.textLabel.text = @"新版本检测";
        }else if (indexPath.row == 1){
            cell.imageView.image = [UIImage imageNamed:@"rubbish_2.png"];
            cell.textLabel.text = @"清除缓存";
        }else if (indexPath.row == 2){
            cell.imageView.image = [UIImage imageNamed:@"tri_arrow.png"];
            cell.textLabel.text = @"消息推送";
        }else if (indexPath.row == 3){
            cell.imageView.image = [UIImage imageNamed:@"key_icon.png"];
            cell.textLabel.text = @"修改密码";
        }else if (indexPath.row == 4){
            cell.imageView.image = [UIImage imageNamed:@"close_icon.png"];
            cell.textLabel.text = @"屏蔽管理";
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    if (2 == indexPath.section) {
        static BOOL nibRegister = NO;
        if (!nibRegister) {
            UINib *nib = [UINib nibWithNibName:@"FXTableViewSheZhiCell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:nil];
        }
        FXTableViewSheZhiCell *cell = [[FXTableViewSheZhiCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [cell setlabel];
        cell.setName.text = @"系统公告管理";
        cell.setImage.image = [UIImage imageNamed:@"book_icon"];
    }
    return nil;
    
}
-(void)buttonclick
{
    NSLog(@"button事件");
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return  80;
    }
    else
        return 40;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height;
    if (section==0) {
        height = 5;
    }else if(section == 1){
        height = 0;
    }else if(section == 2){
        height = 0;
    }
    return height;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat height;
//    if (section==2) {
//        height = 150;
//    }else{
//        height =0;
//    }
    height = 0;
    return height;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (indexPath.row == 2) {
            FXTuiSongViewController *tuisong = [[FXTuiSongViewController alloc]init];
            [self.navigationController pushViewController:tuisong animated:YES];
        }else if (indexPath.row == 0){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"版本更新提示" message:@"当前版本为最新版本" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }else if (indexPath.row == 1){
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:nil message:@"是否清楚缓存" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"下次清除", nil];
            [alter show];
        }else if(indexPath.row == 3){
            FXXiuGaiMiMaViewController *xiugai = [[FXXiuGaiMiMaViewController alloc]init];
            [self.navigationController pushViewController:xiugai animated:YES];
        }else if (indexPath.row == 4){
            FXPingBiGuanLiViewController *pingbi = [[FXPingBiGuanLiViewController alloc]init];
            [self.navigationController pushViewController:pingbi animated:YES];
        }else
        {
            FXSystemInfoViewController *sysinfo = [[FXSystemInfoViewController alloc]init];
            [self.navigationController pushViewController:sysinfo animated:YES];
        }
    }else if (indexPath.section == 2){
        NSLog(@"用户退出");
    }else{
        FXMyInfoViewController *myInfo = [[FXMyInfoViewController alloc]init];
        [self.navigationController pushViewController:myInfo animated:YES];
    }
        
}
- (void)hiddenExtraCellLine {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [self.setTable setTableFooterView:view];
}
@end
