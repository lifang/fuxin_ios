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
#import "LHLDBTools.h"
#import "FXArchiverHelper.h"
#import "FXTextFormat.h"
#import "FXFileHelper.h"

#define kBackViewTag      100
#define kLabelTag         101

@interface FXSettingController ()<UIAlertViewDelegate>

@end

@implementation FXSettingController

@synthesize settingTableView = _settingTableView;

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [FXAppDelegate showFuWuTitleForViewController:self];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    [self getUserInfo];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserInfo:) name:UpdateUserInfoNotification object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"setting"];

}

- (void)viewDidDisappear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"setting"];
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
                [self updateUserInfoWithProfile:resp.profile];
//                NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
//                [_settingTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationNone];
            }
            else {
                //获取失败
                NSLog(@"获取个人%d",resp.isSucceed);
            }
        }
        else {
            //请求失败
        }
    }];
}

- (void)updateUserInfoWithProfile:(Profile *)profile {
    FXAppDelegate *delegate = [FXAppDelegate shareFXAppDelegate];
    FXUserModel *user = [[FXUserModel alloc] init];
    user.userID = [NSNumber numberWithInt:profile.userId];
    user.name = profile.name;
    user.nickName = profile.nickName;
    user.genderType = [NSNumber numberWithInt:profile.gender];
    user.mobilePhoneNum = profile.mobilePhoneNum;
    user.email = profile.email;
    user.birthday = profile.birthday;
    user.isProvider = [NSNumber numberWithBool:profile.isProvider];
    user.lisence = profile.lisence;
    user.isAuth = [NSNumber numberWithBool:profile.isAuthentication];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (!profile.tileUrl || [profile.tileUrl isEqualToString:@""]) {
            user.tile = UIImageJPEGRepresentation([UIImage imageNamed:@"placeholder.png"], 1.0);
        }
        else {
            if (![delegate.user.tileURL isEqualToString:profile.tileUrl]) {
                user.tileURL = profile.tileUrl;
                user.tile = [NSData dataWithContentsOfURL:[NSURL URLWithString:user.tileURL]];
            }
            else {
                user.tileURL = profile.tileUrl;
                user.tile = delegate.user.tile;
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^ {
            [FXArchiverHelper saveUserInfo:user];
            delegate.user = user;
            NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
            [_settingTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationNone];
        });
    });
    
//    if (!profile.tileUrl || [profile.tileUrl isEqualToString:@""]) {
//        user.tile = UIImageJPEGRepresentation([UIImage imageNamed:@"placeholder.png"], 1.0);
//    }
//    else {
//        if (![delegate.user.tileURL isEqualToString:profile.tileUrl]) {
//            user.tileURL = profile.tileUrl;
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                user.tile = [NSData dataWithContentsOfURL:[NSURL URLWithString:user.tileURL]];
//                [FXArchiverHelper saveUserInfo:user];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    delegate.user = user;
//                    
//                    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
//                    [_settingTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationNone];
//                });
//            });
//        }
//    }
}

- (void)showUserInfoWithCell:(FXSettingUserCell *)cell {
    FXAppDelegate *delegate = [FXAppDelegate shareFXAppDelegate];
    if (delegate.user) {
        if (delegate.user.nickName) {
            //有昵称显示昵称 没有显示名字
            cell.nameLabel.text = delegate.user.nickName;
        }
        else {
            cell.nameLabel.text = delegate.user.name;
        }
        //性别
        if ([delegate.user.genderType intValue] == 0) {
            cell.sexView.image = [UIImage imageNamed:@"male.png"];
        }
        else if ([delegate.user.genderType intValue] == 1) {
            cell.sexView.image = [UIImage imageNamed:@"female.png"];
        }
        else if ([delegate.user.genderType intValue] == 2) {
            //保密
        }
        //头像
        if (delegate.user.tile && [delegate.user.tile length] > 0) {
            cell.photoView.image = [UIImage imageWithData:delegate.user.tile];
        }
        else {
            cell.photoView.image = [UIImage imageNamed:@"placeholder.png"];
        }
        //小图标显示
        BOOL showFirst = NO,showSecond = NO,showThird = NO;
        if ([delegate.user.isAuth boolValue]) {
            showFirst = YES;
        }
        if (delegate.user.email && ![delegate.user.email isEqualToString:@""]) {
            showSecond = YES;
        }
        if (delegate.user.mobilePhoneNum && ![delegate.user.mobilePhoneNum isEqualToString:@""]) {
            showThird = YES;
        }
        [cell showRealName:showFirst showMessage:showSecond showPhone:showThird];
    }
}

#pragma mark - 更新界面通知
- (void)updateUserInfo:(NSNotification *)notification {
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    [_settingTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        static NSString *firstIdentifier = @"first";
        FXSettingUserCell *cell = [tableView dequeueReusableCellWithIdentifier:firstIdentifier];
        if (cell == nil) {
            cell = [[FXSettingUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:firstIdentifier];
        }
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
//    else if (indexPath.row == 6) {
//        static NSString *thirdIdentifer = @"third";
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:thirdIdentifer];
//        if (cell == nil) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:thirdIdentifer];
//            UIImageView *backView = [[UIImageView alloc] initWithFrame:CGRectMake(180, 13, 20, 20)];
//            backView.tag = kBackViewTag;
//            backView.image = [UIImage imageNamed:@"messnum.png"];
//            [cell.contentView addSubview:backView];
//            
//            UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, 3, 14, 14)];
//            numberLabel.tag = kLabelTag;
//            numberLabel.backgroundColor = [UIColor clearColor];
//            numberLabel.font = [UIFont systemFontOfSize:10];
//            numberLabel.textColor = [UIColor whiteColor];
//            numberLabel.textAlignment = NSTextAlignmentCenter;
//            [backView addSubview:numberLabel];
//        }
//        cell.textLabel.font = [UIFont systemFontOfSize:15];
//        cell.imageView.image = [UIImage imageNamed:@"setting6.png"];
//        cell.textLabel.text = @"系统公告管理";
//        
//        UIImageView *backView = (UIImageView *)[cell.contentView viewWithTag:kBackViewTag];
//        UILabel *label = (UILabel *)[backView viewWithTag:kLabelTag];
//        label.text = @"8";
//        //显示
//        backView.hidden = NO;
//        if (label.text.length >= 3) {
//            label.font = [UIFont systemFontOfSize:7];
//            label.text = @"99+";
//        }
//        else {
//            label.font = [UIFont systemFontOfSize:10];
//            if (label.text == nil || [label.text isEqualToString:@""]) {
//                backView.hidden = YES;
//            }
//        }
//        return cell;
//    }
    else if (indexPath.row == 6) {
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
            FXAppDelegate *delegate = [FXAppDelegate shareFXAppDelegate];
            FXUserSettingController *user = [[FXUserSettingController alloc] init];
            user.userInfo = delegate.user;
            user.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:user animated:YES];
        }
            break;
        case 2: {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                            message:@"确定要清空本地的所有聊天记录？"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定", nil];
            [alert show];
        }
            break;
        case 4: {
            FXModifyPasswordController *modifyPassword = [[FXModifyPasswordController alloc] init];
//            self.tabBarController.tabBar.hidden = YES;
            [self.navigationController pushViewController:modifyPassword animated:YES];
        }
            break;
        case 5:{
            FXBlockedContactsController *blockedContacts = [[FXBlockedContactsController alloc] init];
            [self.navigationController pushViewController:blockedContacts animated:YES];
        }
            break;
//        case 6:{
//            FXNotificationManageViewController *notificationManage = [[FXNotificationManageViewController alloc] init];
//            [self.navigationController pushViewController:notificationManage animated:YES];
//        }
//            break;
        case 6: {
            //退出
            FXAppDelegate *delegate = [FXAppDelegate shareFXAppDelegate];
            [FXRequestDataFormat authenticationOutWithToken:delegate.token UserID:delegate.userID Finished:^(BOOL success, NSData *response) {
                if (success) {
                    //请求成功
                    UnAuthenticationResponse *resp = [UnAuthenticationResponse parseFromData:response];
                    NSLog(@"退出%d",resp.isSucceed);
                    if (resp.isSucceed) {
                        //返回成功
                    }
                    else {
                        //返回失败
                    }
                }
                else {
                    //请求失败
                }
            }];
            delegate.token = nil;
            delegate.userID = -1;
            delegate.user = nil;
            [[delegate shareRootViewContorller] showLoginViewController];
            [[delegate shareRootViewContorller] removeMainController];
            
        }
            break;
        default:
            break;
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        [LHLDBTools deleteAllConversationsWithFinished:^(BOOL finish) {
            
        }];
        [FXFileHelper removeAllChatImage];
        [LHLDBTools deleteAllChattingRecordWithFinished:^(BOOL finish) {
            if (finish) {
                //更新对话界面
                [[NSNotificationCenter defaultCenter] postNotificationName:ChatNeedRefreshListNotification object:nil];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                                message:@"清除聊天记录完毕"
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles: nil];
                [alert show];
            }
        }];
    }
}

@end
