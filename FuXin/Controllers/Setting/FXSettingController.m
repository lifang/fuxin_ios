//
//  FXSettingController.m
//  FuXin
//
//  Created by 徐宝桥 on 14-6-2.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXSettingController.h"
#import "FXSettingUserCell.h"
#import "FXUserInfoController.h"
#import "FXModifyPasswordController.h"
#import "FXRequestDataFormat.h"
#import "FXBlockedContactsController.h"
#import "FXNotificationManageViewController.h"
#import "LHLDBTools.h"
#import "FXArchiverHelper.h"
#import "FXTextFormat.h"
#import "FXFileHelper.h"
#import "SharedClass.h"
#import "FXPushViewController.h"
#import "FXAboutViewController.h"

#define kBackViewTag      100
#define kLabelTag         101
//更新
#define kUpdateTag        1000
#define kDeleteTag        1001

#define kAppID            @"883096371"

@interface FXSettingController ()<UIAlertViewDelegate>

@property (nonatomic, assign) BOOL isRequest;
@property (nonatomic, strong) UIView *footerView;

@end

@implementation FXSettingController

@synthesize settingTableView = _settingTableView;
@synthesize isRequest = _isRequest;

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        [FXAppDelegate showFuWuTitleForViewController:self];
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
    [self initFooterView];
    _settingTableView.tableFooterView = _footerView;
}

- (void)hiddenExtraCellLineWithTableView:(UITableView *)table {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [table setTableFooterView:view];
}

- (void)initFooterView {
    _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 120)];
    _footerView.backgroundColor = [UIColor clearColor];
    _footerView.userInteractionEnabled = YES;
    UIButton *loginOutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginOutBtn.layer.cornerRadius = 4;
    loginOutBtn.frame = CGRectMake(30, 40, 260, 43);
    loginOutBtn.backgroundColor = kColor(210, 210, 210, 1);
    [loginOutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginOutBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [loginOutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [loginOutBtn addTarget:self action:@selector(loginOut) forControlEvents:UIControlEventTouchUpInside];
    [_footerView addSubview:loginOutBtn];
    
//    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
//    line.backgroundColor = kColor(200, 200, 200, 1);
//    [_footerView addSubview:line];
}

#pragma mark - 请求

- (void)getUserInfo {
    FXAppDelegate *delegate = [FXAppDelegate shareFXAppDelegate];
    [FXRequestDataFormat getProfileWithToken:delegate.token UserID:delegate.userID Finished:^(BOOL success, NSData *response) {
        if (success) {
            //请求成功
            ProfileResponse *resp = [ProfileResponse parseFromData:response];
            if (resp.isSucceed) {
                NSLog(@"!!%@",resp.profile.fuzhi);
                NSLog(@"!!%@",resp.profile.location);
                NSLog(@"!!%@",resp.profile.description);
                for (int i = 0 ; i < [resp.profile.licensesList count] ; i++) {
                    License *lice = [resp.profile.licensesList objectAtIndex:i];
                    NSLog(@"!!%@,!!%@,!!%d",lice.name,lice.iconUrl,lice.order);
                }
                //获取成功
                [self updateUserInfoWithProfile:resp.profile];
            }
            else {
                //获取失败
                if (!self.errorHandler) {
                    self.errorHandler = [[FXReuqestError alloc] init];
                }
                [self.errorHandler requestDidFailWithErrorCode:resp.errorCode];
                NSLog(@"获取个人%d",resp.isSucceed);
            }
        }
        else {
            //请求失败
        }
    }];
}

- (void)loginOut {
    //推送注销
    [self resignPushInfo];
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
    delegate.enablePush = NO;
    //数据库操作保存id
    [SharedClass sharedObject].userID = nil;
    [[delegate shareRootViewContorller] showLoginViewController];
    [[delegate shareRootViewContorller] removeMainController];
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
    user.fuzhi = profile.fuzhi;
    user.location = profile.location;
    user.description = profile.description;
    user.licences = profile.licensesList;
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        if (!profile.backgroundUrl || [profile.backgroundUrl isEqualToString:@""]) {
//            //背景链接为空
//        }
//        else {
//            if (![delegate.user.backgroundURL isEqualToString:profile.backgroundUrl]) {
//                //更新背景
//                user.backgroundURL = profile.backgroundUrl;
//                NSData *backData = [NSData dataWithContentsOfURL:[NSURL URLWithString:user.backgroundURL]];
//                [FXFileHelper documentSaveImageData:backData withName:user.backgroundURL withPathType:PathForHeadImage];
//            }
//            else {
//                //url相同但是图片未下载成功
//                UIImage *image = [UIImage imageWithData:[FXFileHelper headImageWithName:user.backgroundURL]];
//                if (!image) {
//                    [FXFileHelper removeAncientHeadImageIfExistWithName:user.backgroundURL];
//                    NSData *backData = [NSData dataWithContentsOfURL:[NSURL URLWithString:user.backgroundURL]];
//                    [FXFileHelper documentSaveImageData:backData withName:user.backgroundURL withPathType:PathForHeadImage];
//                }
//            }
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [FXArchiverHelper saveUserInfo:user];
//                delegate.user = user;
//            });
//        }
//    });
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        if (!profile.tileUrl || [profile.tileUrl isEqualToString:@""]) {
//            //下载的用户头像url为空
//            user.tile = UIImageJPEGRepresentation([UIImage imageNamed:@"placeholder.png"], 1.0);
//        }
//        else {
//            if (![delegate.user.tileURL isEqualToString:profile.tileUrl]) {
//                //更新头像
//                user.tileURL = profile.tileUrl;
//                user.tile = [NSData dataWithContentsOfURL:[NSURL URLWithString:user.tileURL]];
//            }
//            else {
//                //未更新头像
//                user.tileURL = profile.tileUrl;
//                user.tile = delegate.user.tile;
//            }
//        }
//        dispatch_async(dispatch_get_main_queue(), ^ {
//            [FXArchiverHelper saveUserInfo:user];
//            delegate.user = user;
//            NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
//            [_settingTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationNone];
//        });
//    });
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (!profile.backgroundUrl || [profile.backgroundUrl isEqualToString:@""]) {
            //背景链接为空
        }
        else {
            user.backgroundURL = profile.backgroundUrl;
            if (![delegate.user.backgroundURL isEqualToString:profile.backgroundUrl]) {
                //更新背景
                NSData *backData = [self loadBackgroundWithURLString:user.backgroundURL];
//                NSData *backData = [NSData dataWithContentsOfURL:[NSURL URLWithString:user.backgroundURL]];
                [FXFileHelper documentSaveImageData:backData withName:user.backgroundURL withPathType:PathForHeadImage];
            }
            else {
                //url相同但是图片未下载成功
                UIImage *image = [UIImage imageWithData:[FXFileHelper headImageWithName:user.backgroundURL]];
                if (!image) {
                    [FXFileHelper removeAncientHeadImageIfExistWithName:user.backgroundURL];
                    NSData *backData = [self loadBackgroundWithURLString:user.backgroundURL];
//                    NSData *backData = [NSData dataWithContentsOfURL:[NSURL URLWithString:user.backgroundURL]];
                    [FXFileHelper documentSaveImageData:backData withName:user.backgroundURL withPathType:PathForHeadImage];
                }
            }
        }
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (!profile.tileUrl || [profile.tileUrl isEqualToString:@""]) {
            //下载的用户头像url为空
            user.tile = UIImageJPEGRepresentation([UIImage imageNamed:@"placeholder.png"], 1.0);
        }
        else {
            if (![delegate.user.tileURL isEqualToString:profile.tileUrl]) {
                //更新头像
                user.tileURL = profile.tileUrl;
                user.tile = [NSData dataWithContentsOfURL:[NSURL URLWithString:user.tileURL]];
            }
            else {
                //未更新头像
                user.tileURL = profile.tileUrl;
                user.tile = delegate.user.tile;
            }
        }
    });
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        [FXArchiverHelper saveUserInfo:user];
        delegate.user = user;
        dispatch_async(dispatch_get_main_queue(), ^{
            NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
            [_settingTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationNone];
        });
    });
}

//临时
- (NSData *)loadBackgroundWithURLString:(NSString *)url {
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setValidatesSecureCertificate:NO];
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request startSynchronous];
    return request.responseData;
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
//        cell.remarkLabel.text = delegate.user.nickName;
        //性别
//        if ([delegate.user.genderType intValue] == 0) {
//            cell.sexView.image = [UIImage imageNamed:@"male.png"];
//        }
//        else if ([delegate.user.genderType intValue] == 1) {
//            cell.sexView.image = [UIImage imageNamed:@"female.png"];
//        }
//        else if ([delegate.user.genderType intValue] == 2) {
//            //保密
//        }
        //头像
        if (delegate.user.tile && [delegate.user.tile length] > 0) {
            cell.photoView.image = [UIImage imageWithData:delegate.user.tile];
        }
        else {
            cell.photoView.image = [UIImage imageNamed:@"placeholder.png"];
        }
        //小图标显示
//        BOOL showFirst = NO,showSecond = NO,showThird = NO;
//        if ([delegate.user.isAuth boolValue]) {
//            showFirst = YES;
//        }
//        if (delegate.user.email && ![delegate.user.email isEqualToString:@""]) {
//            showSecond = YES;
//        }
//        if (delegate.user.mobilePhoneNum && ![delegate.user.mobilePhoneNum isEqualToString:@""]) {
//            showThird = YES;
//        }
//        [cell showRealName:showFirst showMessage:showSecond showPhone:showThird];
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
    else if (indexPath.row <= 6) {
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
            case 6: {
                cell.imageView.image = [UIImage imageNamed:@"setting6.png"];
                cell.textLabel.text = @"关于我们";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            default:
                break;
        }
        return cell;
    }
//    else if (indexPath.row == 6) {
//        static NSString *forthIdentifer = @"forth";
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:forthIdentifer];
//        if (cell == nil) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:forthIdentifer];
//            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, 1)];
//            line.backgroundColor = kColor(204, 204, 204, 3);
//            [cell.contentView addSubview:line];
//            cell.textLabel.font = [UIFont systemFontOfSize:15];
//        }
//        cell.imageView.image = [UIImage imageNamed:@"setting7.png"];
//        cell.textLabel.text = @"退出登录";
//        return cell;
//    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 80;
    }
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0: {
//            FXAppDelegate *delegate = [FXAppDelegate shareFXAppDelegate];
            FXUserInfoController *user = [[FXUserInfoController alloc] init];
//            user.userInfo = delegate.user;
            user.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:user animated:YES];
        }
            break;
        case 1: {
            if (!_isRequest) {
                [self checkVersion];
                _isRequest = YES;
            }
        }
            break;
        case 2: {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                            message:@"确定要清空本地的所有聊天记录？"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定", nil];
            alert.tag = kDeleteTag;
            [alert show];
        }
            break;
        case 3: {
            FXPushViewController *push = [[FXPushViewController alloc] init];
            push.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:push animated:YES];
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
        case 6: {
            FXAboutViewController *aboutC = [[FXAboutViewController alloc] init];
            [self.navigationController pushViewController:aboutC animated:YES];
        }
            break;
//        case 6:{
//            FXNotificationManageViewController *notificationManage = [[FXNotificationManageViewController alloc] init];
//            [self.navigationController pushViewController:notificationManage animated:YES];
//        }
//            break;
        default:
            break;
    }
}

- (void)resignPushInfo {
    //设置推送相关
    FXAppDelegate *delegate = [FXAppDelegate shareFXAppDelegate];
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDict objectForKey:@"CFBundleVersion"];
    ClientInfo *client = [[[[[[[[[ClientInfo builder]
                                setDeviceId:delegate.push_deviceToken]
                               setOsType:ClientInfo_OSTypeIos]
                              setOsversion:[[UIDevice currentDevice] systemVersion]]
                             setUserId:delegate.userID]
                            setChannel:kPushChannel]
                            setClientVersion:currentVersion]
                           setIsPushEnable:NO] build];
    [FXRequestDataFormat clientInfoWithToken:delegate.token UserID:delegate.userID Client:client Finished:^(BOOL success, NSData *response) {
        if (success) {
            //请求成功
            ClientInfoResponse *resp = [ClientInfoResponse parseFromData:response];
            if (resp.isSucceed) {
                //接收成功
                NSLog(@"push success");
            }
            else {
                //接收失败
                NSLog(@"push = %d",resp.errorCode);
            }
        }
    }];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        if (alertView.tag == kDeleteTag) {
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
        else if (alertView.tag == kUpdateTag) {
            NSString *url = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@",kAppID];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
    }
}

#pragma mark - 更新

- (void)checkVersion {
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDict objectForKey:@"CFBundleVersion"];
    //883096371
    NSString *url = @"http://itunes.apple.com/lookup?id=883096371";

    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request startAsynchronous];
    
    __weak ASIFormDataRequest *wRequest = request;
    [request setCompletionBlock:^{
        _isRequest = NO;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[wRequest responseData] options:0 error:nil];
        NSArray *infoArray = [dict objectForKey:@"results"];
        if ([infoArray count] > 0) {
            NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
            NSString *lastVersion = [releaseInfo objectForKey:@"version"];
            if (![lastVersion isEqualToString:currentVersion]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                                message:@"有新的版本更新，是否前往更新?"
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"更新", nil];
                alert.tag = kUpdateTag;
                [alert show];
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                                message:@"此版本已经是最新版本！"
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
                [alert show];
            }
        }
    }]; 
    [request setFailedBlock:^{
        _isRequest = NO;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"请求失败，请重新加载！"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }];
}


@end
