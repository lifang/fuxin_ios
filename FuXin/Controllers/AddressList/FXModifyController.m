//
//  FXModifyController.m
//  FuXin
//
//  Created by 徐宝桥 on 14-7-16.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXModifyController.h"
#import "LHLDBTools.h"
#import "FXArchiverHelper.h"

@interface FXModifyController ()<UITextFieldDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UITextField *nameFeild;

@property (nonatomic, assign) BOOL isRequest;

@end

@implementation FXModifyController

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
    [self setLeftNavBarItemWithImageName:@"back.png"];
    [self setRightNavBarItemWithImageName:@"save.png"];
    if (_type == ModifyContact) {
        self.title = @"设置备注";
    }
    else {
        self.title = @"修改昵称";
    }
    [self initUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 重写
- (void)rightBarTouched:(id)sender {
    if (_type == ModifyContact) {
        [self modifyContactRemark:_nameFeild.text];
    }
    else if (_type == ModifyUser) {
        [self modifyUserWithNickName:_nameFeild.text];
    }
}

#pragma mark - UI

- (void)initUI {
    _nameFeild = [[UITextField alloc] init];
    _nameFeild.delegate = self;
    _nameFeild.font = [UIFont boldSystemFontOfSize:15];
    _nameFeild.returnKeyType = UIReturnKeyDone;
    _nameFeild.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    _modifyTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, kScreenHeight - 64) style:UITableViewStylePlain];
    _modifyTable.delegate = self;
    _modifyTable.dataSource = self;
    _modifyTable.scrollEnabled = NO;
    [self.view addSubview:_modifyTable];
    [self hiddenExtraCellLineWithTableView:_modifyTable];
    if (kDeviceVersion >= 7.0) {
        _modifyTable.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

- (void)hiddenExtraCellLineWithTableView:(UITableView *)table {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [table setTableFooterView:view];
}

#pragma mark - 修改联系人

- (void)modifyContactRemark:(NSString *)remark {
    if (_isRequest) {
        return;
    }
    _isRequest = YES;
    Contact *contact = [[[[[[[[[[[[[[[[Contact builder]
                                      setContactId:[_contact.contactID intValue]]
                                     setName:_contact.contactNickname]
                                    setCustomName:remark]
                                   setPinyin:_contact.contactPinyin]
                                  setIsBlocked:_contact.contactIsBlocked]
                                 setLastContactTime:_contact.contactLastContactTime]
                                setGender:(Contact_GenderType)_contact.contactSex]
                               setSource:_contact.contactRelationship]
                              setTileUrl:_contact.contactAvatarURL]
                             setIsProvider:_contact.contactIsProvider]
                            setLisence:_contact.contactLisence]
                           setIndividualResume:_contact.contactSignature]
                          setOrderTime:_contact.orderTime]
                         setSubscribeTime:_contact.subscribeTime] build];
    FXAppDelegate *delegate = [FXAppDelegate shareFXAppDelegate];
    [FXRequestDataFormat modifyContactDetailWithToken:delegate.token UserID:delegate.userID Contact:contact Finished:^(BOOL success, NSData *response) {
        _isRequest = NO;
        if (success) {
            //请求成功
            ChangeContactDetailResponse *resp = [ChangeContactDetailResponse parseFromData:response];
            NSString *info = @"";
            id delegate = nil;
            if (resp.isSucceed) {
                //修改成功
                _contact.contactRemark = remark;
                [self updateAfterModify];
                info = @"修改联系人备注成功";
                delegate = self;
            }
            else {
                //修改失败
                if (!self.errorHandler) {
                    self.errorHandler = [[FXReuqestError alloc] init];
                }
                [self.errorHandler requestDidFailWithErrorCode:resp.errorCode];
                info = @"修改联系人备注失败";
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                            message:info
                                                           delegate:delegate
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        else {
            //请求失败
        }
    }];
}


//修改联系人成功后更新界面
- (void)updateAfterModify {
    //更新联系人到数据库
    [LHLDBTools saveContact:[NSArray arrayWithObject:_contact] withFinished:^(BOOL finish) {
        NSLog(@"update success!");
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:AddressNeedRefreshListNotification object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:ChatNeedRefreshListNotification object:nil];
}

#pragma mark - 修改登录用户

- (void)modifyUserWithNickName:(NSString *)nickName {
    if (!_isRequest) {
        _isRequest = YES;
        FXAppDelegate *delegate = [FXAppDelegate shareFXAppDelegate];
        [FXRequestDataFormat
         changeProfileWithToken:delegate.token UserID:delegate.userID
         Signature:nil
         Tiles:nil
         ContentType:nil
         NickName:nickName
         Finished:^(BOOL success, NSData *response) {
             _isRequest = NO;
             NSString *info = @"";
             id delegate = nil;
             if (success) {
                 //请求成功
                 ChangeProfileResponse *resp = [ChangeProfileResponse parseFromData:response];
                 if (resp.isSucceed) {
                     //修改成功
                     [self saveUserInfoWithNewProfile:resp.profile];
                     info = @"修改个人信息成功";
                     delegate = self;
                 }
                 else {
                     //修改失败
                     info = @"修改个人信息失败";
                     if (!self.errorHandler) {
                         self.errorHandler = [[FXReuqestError alloc] init];
                     }
                     [self.errorHandler requestDidFailWithErrorCode:resp.errorCode];
                 }
             }
             else {
                 //请求失败
                 info = @"修改个人信息失败";
             }
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                             message:info
                                                            delegate:delegate
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil];
             [alert show];
         }];
    }
}

- (void)saveUserInfoWithNewProfile:(Profile *)profile {
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
    user.tileURL = profile.tileUrl;
    user.isAuth = [NSNumber numberWithBool:profile.isAuthentication];
    user.fuzhi = profile.fuzhi;
    user.tile = _userInfo.tile;
    user.location = profile.location;
    user.description = profile.description;
    FXAppDelegate *delegate = [FXAppDelegate shareFXAppDelegate];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [FXArchiverHelper saveUserInfo:user];
        delegate.user = user;
        _userInfo = user;
        dispatch_async(dispatch_get_main_queue(), ^{
            //更新用户信息通知
            [[NSNotificationCenter defaultCenter] postNotificationName:UpdateUserInfoNotification object:nil];
        });
    });
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    _nameFeild.frame = CGRectMake(10, 7, 300, 36);
    if (_type == ModifyContact) {
        _nameFeild.text = _contact.contactRemark;
    }
    else {
        _nameFeild.text = _userInfo.nickName;
    }
    [_nameFeild becomeFirstResponder];
    [cell.contentView addSubview:_nameFeild];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

#pragma mark - UITextField

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIAlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
