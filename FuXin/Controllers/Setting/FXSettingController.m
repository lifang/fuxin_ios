//
//  FXSettingController.m
//  FuXin
//
//  Created by 徐宝桥 on 14-6-2.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXSettingController.h"
#import "FXSettingUserCell.h"
#import "FXUserSettingController.h"
#import "FXModifyPasswordController.h"
#import "FXRequestDataFormat.h"
#import "FXBlockedContactsController.h"
#import "FXNotificationManageViewController.h"

#define kBackViewTag      100
#define kLabelTag         101

@interface FXSettingController ()

@property (nonatomic, strong) Profile *userInfo;

@end

@implementation FXSettingController

@synthesize settingTableView = _settingTableView;
@synthesize userInfo = _userInfo;

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
    [self initUI];
    [self getUserInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)initUI {
    _settingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, kScreenHeight - 64 - 49) style:UITableViewStylePlain];
    _settingTableView.delegate = self;
    _settingTableView.dataSource = self;
    if (kDeviceVersion > 7.0) {
        _settingTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    [self.view addSubview:_settingTableView];
    [self hiddenExtraCellLineWithTableView:_settingTableView];
}

- (void)hiddenExtraCellLineWithTableView:(UITableView *)table {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [table setTableFooterView:view];
}

#pragma mark - 请求

- (void)getUserInfo {
    FXAppDelegate *delegate = [FXAppDelegate shareFXAppDelegate];
    [FXRequestDataFormat getProfileWithToken:delegate.token UserID:delegate.userID Finished:^(BOOL success, NSData *response) {
        if (success) {
            //请求成功
            ProfileResponse *resp = [ProfileResponse parseFromData:response];
            if (resp.isSucceed) {
                //获取成功
                _userInfo = resp.profile;
                NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
                [_settingTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationNone];
                NSLog(@"name = %@,nickName = %@,gender = %d,mob = %@,email = %@,birth = %@,tile = %@,is = %d,li = %@,type = %@",resp.profile.name,resp.profile.nickName,resp.profile.gender,resp.profile.mobilePhoneNum,resp.profile.email,resp.profile.birthday,resp.profile.tileUrl,resp.profile.isProvider,resp.profile.lisence,resp.profile.publishClassType);
            }
            else {
                //获取失败
            }
        }
        else {
            //请求失败
        }
    }];
}

- (void)showUserInfoWithCell:(FXSettingUserCell *)cell {
    cell.nameLabel.text = _userInfo.name;
    if (_userInfo.gender == 0) {
        cell.sexView.image = [UIImage imageNamed:@"male.png"];
    }
    else {
        cell.sexView.image = [UIImage imageNamed:@"female.png"];
    }
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        static NSString *firstIdentifier = @"first";
        FXSettingUserCell *cell = [tableView dequeueReusableCellWithIdentifier:firstIdentifier];
        if (cell == nil) {
            cell = [[FXSettingUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:firstIdentifier];
        }
        cell.photoView.image = [UIImage imageNamed:@"placeholder.png"];
        [self showUserInfoWithCell:cell];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        return cell;
    }
    else if (indexPath.row <= 5) {
        static NSString *secondIdentifier = @"second";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:secondIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:secondIdentifier];
            cell.textLabel.font = [UIFont systemFontOfSize:15];
        }
        switch (indexPath.row) {
            case 1: {
                cell.imageView.image = [UIImage imageNamed:@"setting1.png"];
                cell.textLabel.text = @"新版本检测";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
                break;
            case 2: {
                cell.imageView.image = [UIImage imageNamed:@"setting2.png"];
                cell.textLabel.text = @"清除全部聊天记录";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
                break;
            case 3: {
                cell.imageView.image = [UIImage imageNamed:@"setting3.png"];
                cell.textLabel.text = @"消息推送";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
                break;
            case 4: {
                cell.imageView.image = [UIImage imageNamed:@"setting4.png"];
                cell.textLabel.text = @"修改密码";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
                break;
            case 5: {
                cell.imageView.image = [UIImage imageNamed:@"setting5.png"];
                cell.textLabel.text = @"屏蔽管理";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
                break;
            default:
                break;
        }
        return cell;
    }
    else if (indexPath.row == 6) {
        static NSString *thirdIdentifer = @"third";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:thirdIdentifer];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:thirdIdentifer];
            UIImageView *backView = [[UIImageView alloc] initWithFrame:CGRectMake(180, 13, 20, 20)];
            backView.tag = kBackViewTag;
            backView.image = [UIImage imageNamed:@"messnum.png"];
            [cell.contentView addSubview:backView];
            
            UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, 3, 14, 14)];
            numberLabel.tag = kLabelTag;
            numberLabel.backgroundColor = [UIColor clearColor];
            numberLabel.font = [UIFont systemFontOfSize:10];
            numberLabel.textColor = [UIColor whiteColor];
            numberLabel.textAlignment = NSTextAlignmentCenter;
            [backView addSubview:numberLabel];
        }
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.imageView.image = [UIImage imageNamed:@"setting6.png"];
        cell.textLabel.text = @"系统公告管理";
        
        UIImageView *backView = (UIImageView *)[cell.contentView viewWithTag:kBackViewTag];
        UILabel *label = (UILabel *)[backView viewWithTag:kLabelTag];
        label.text = @"8";
        //显示
        backView.hidden = NO;
        if (label.text.length >= 3) {
            label.font = [UIFont systemFontOfSize:7];
            label.text = @"99+";
        }
        else {
            label.font = [UIFont systemFontOfSize:10];
            if (label.text == nil || [label.text isEqualToString:@""]) {
                backView.hidden = YES;
            }
        }
        return cell;
    }
    else if (indexPath.row == 7) {
        static NSString *forthIdentifer = @"forth";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:forthIdentifer];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:forthIdentifer];
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, 1)];
            line.backgroundColor = kColor(204, 204, 204, 3);
            [cell.contentView addSubview:line];
            cell.textLabel.font = [UIFont systemFontOfSize:15];
        }
        cell.imageView.image = [UIImage imageNamed:@"setting7.png"];
        cell.textLabel.text = @"退出登录";
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 70;
    }
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0: {
            FXUserSettingController *user = [[FXUserSettingController alloc] init];
            user.userInfo = _userInfo;
            user.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:user animated:YES];
        }
            break;
        
        case 4: {
            FXModifyPasswordController *modifyPassword = [[FXModifyPasswordController alloc] init];
            [self.navigationController pushViewController:modifyPassword animated:YES];
        }
            break;
        case 5:{
            FXBlockedContactsController *blockedContacts = [[FXBlockedContactsController alloc] init];
            [self.navigationController pushViewController:blockedContacts animated:YES];
        }
            break;
        case 6:{
            FXNotificationManageViewController *notificationManage = [[FXNotificationManageViewController alloc] init];
            [self.navigationController pushViewController:notificationManage animated:YES];
        }
            break;
        default:
            break;
    }
}

@end
