//
//  FXPushViewController.m
//  FuXin
//
//  Created by 徐宝桥 on 14-6-16.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXPushViewController.h"

#define kLabelTag       100

@interface FXPushViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation FXPushViewController

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
    self.title = @"消息推送";
    
    [self setLeftNavBarItemWithImageName:@"back.png"];
    [self initUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)initUI {
    _pushTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, kScreenHeight - 64) style:UITableViewStyleGrouped];
    _pushTable.delegate = self;
    _pushTable.dataSource = self;
    [self.view addSubview:_pushTable];
    [self hiddenExtraCellLineWithTableView:_pushTable];
    
    FXAppDelegate *delegate = [FXAppDelegate shareFXAppDelegate];
    _switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [_switchButton setOn:delegate.enablePush];
    [_switchButton addTarget:self action:@selector(pushEnable:) forControlEvents:UIControlEventValueChanged];
}

- (void)hiddenExtraCellLineWithTableView:(UITableView *)table {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [table setTableFooterView:view];
}

#pragma mark - action

- (void)pushEnable:(UISwitch *)switchBtn {
    BOOL isEnable = switchBtn.isOn;
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
                           setIsPushEnable:isEnable] build];
    [FXRequestDataFormat clientInfoWithToken:delegate.token UserID:delegate.userID Client:client Finished:^(BOOL success, NSData *response) {
        NSString *message = @"";
        if (success) {
            //请求成功
            ClientInfoResponse *resp = [ClientInfoResponse parseFromData:response];
            if (resp.isSucceed) {
                //接收成功
                if (isEnable) {
                    message = @"您已成功开启消息推送，请确保在iPhone的“设置”-“通知”中也开启推送通知！";
                }
                else {
                    message = @"您已成功关闭消息推送，在应用进入后台后您将不会收到推送消息！";
                }
                delegate.enablePush = isEnable;
            }
            else {
                //接收失败
                NSLog(@"push = %d",resp.errorCode);
                message = @"设置消息推送失败！";
                [switchBtn setOn:!switchBtn.isOn];
                if (!self.errorHandler) {
                    self.errorHandler = [[FXReuqestError alloc] init];
                }
                [self.errorHandler requestDidFailWithErrorCode:resp.errorCode];
            }
        }
        else {
            //请求失败
            message = @"设置消息推送失败！";
            [switchBtn setOn:!switchBtn.isOn];
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }];
}

#pragma mark - UITableView 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 100, 20)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.tag = kLabelTag;
        [cell.contentView addSubview:titleLabel];
    }
    if (indexPath.row == 0) {
        UILabel *label = (UILabel *)[cell.contentView viewWithTag:kLabelTag];
        label.text = @"消息主动推送";
        
        if (kDeviceVersion >= 7.0) {
            _switchButton.onTintColor = [UIColor redColor];
            _switchButton.frame = CGRectMake(260, 10, 50, 30);
        }
        else {
            _switchButton.onTintColor = [UIColor redColor];
            _switchButton.frame = CGRectMake(220, 10, 30, 30);
        }
        [cell.contentView addSubview:_switchButton];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return @"若需要开启推送，请同时确保在iPhone的“设置”-“通知”中也开启推送通知！";
    }
    return nil;
}

@end
