//
//  FXLoginController.m
//  FuXin
//
//  Created by 徐宝桥 on 14-5-14.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXLoginController.h"
#import "FXRegisterController.h"
#import "FXForgotPasswordController.h"
#import "FXAppDelegate.h"
#import "LHLDBTools.h"
#import "FXUtility.h"
#import "SharedClass.h"
#import "FXRequestDataFormat.h"
#import "FXArchiverHelper.h"

@interface FXLoginController ()<UITextFieldDelegate>
//@property (assign ,nonatomic) NSTimeInterval seconds;

@property (nonatomic, assign) BOOL isMove;

@end

@implementation FXLoginController

@synthesize userView = _userView;
@synthesize usernameField = _usernameField;
@synthesize passwordField = _passwordField;

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
    self.title = @"福务网";
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kColor(250, 250, 250, 1);
    [self initUI];
    
    if (_usernameField.text && ![_usernameField.text isEqualToString:@""]) {
        [self getUserInfoWithLogin:YES];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"login"];

}

- (void)viewDidDisappear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"login"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)initUI {
    //顶部红色头像框
    _userView = [[FXUserView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    [self.view addSubview:_userView];
    //输入框
    [self setUserNameAndPasswordUI];
    //按钮
    [self setLoginButtonUI];
    
    [self setValueForUI];
}

- (void)setUserNameAndPasswordUI {
    //用户名框
    UIView *userBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    UIImageView *userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    userImageView.image = [UIImage imageNamed:@"username.png"];
    [userBackView addSubview:userImageView];
    _usernameField = [[UITextField alloc] initWithFrame:CGRectMake(30, 115, 260, 36)];
    _usernameField.returnKeyType = UIReturnKeyDone;
    _usernameField.borderStyle = UITextBorderStyleNone;
    _usernameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _usernameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _usernameField.leftViewMode = UITextFieldViewModeAlways;
    _usernameField.leftView = userBackView;
    _usernameField.placeholder = @"输入账号";
    _usernameField.delegate = self;
    [_usernameField addTarget:self action:@selector(getUserInfo) forControlEvents:UIControlEventEditingDidEnd];
    [self.view addSubview:_usernameField];
    //划线
    CGRect rect = _usernameField.frame;
    UIView *userLineView = [[UIView alloc] initWithFrame:CGRectMake(rect.origin.x, rect.origin.y + rect.size.height + 1, rect.size.width, 1)];
    userLineView.backgroundColor = kColor(209, 27, 33, 0.3);
    [self.view addSubview:userLineView];
    
    //密码框
    UIView *psdBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    UIImageView *psdImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    psdImageView.image = [UIImage imageNamed:@"password.png"];
    [psdBackView addSubview:psdImageView];
    _passwordField = [[UITextField alloc] initWithFrame:CGRectMake(30, 175, 260, 36)];
    _passwordField.returnKeyType = UIReturnKeyDone;
    _passwordField.secureTextEntry = YES;
    _passwordField.borderStyle = UITextBorderStyleNone;
    _passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passwordField.leftViewMode = UITextFieldViewModeAlways;
    _passwordField.leftView = psdBackView;
    _passwordField.placeholder = @"输入密码";
    _passwordField.delegate = self;
    [self.view addSubview:_passwordField];
    //划线
    rect = _passwordField.frame;
    UIView *psdLinsView = [[UIView alloc] initWithFrame:CGRectMake(rect.origin.x, rect.origin.y + rect.size.height + 1, rect.size.width, 1)];
    psdLinsView.backgroundColor = kColor(209, 27, 33, 0.3);
    [self.view addSubview:psdLinsView];
//    [FXArchiverHelper print];
}

- (void)setLoginButtonUI {
    //登录按钮
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.layer.cornerRadius = 4;
    loginButton.frame = CGRectMake(30, 265, 260, 43);
    loginButton.backgroundColor = kColor(209, 27, 33, 1);
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [loginButton setTitle:@"登  录" forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(userLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    //注册按钮
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registerButton.frame = CGRectMake(30, 320, 55, 20);
    registerButton.titleLabel.font = [UIFont systemFontOfSize:13];
    registerButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [registerButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [registerButton setTitle:@"立即注册" forState:UIControlStateNormal];
    [registerButton addTarget:self action:@selector(userRegister:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerButton];
    //忘记密码
    UIButton *forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetButton.frame = CGRectMake(230, 320, 65, 20);
    forgetButton.titleLabel.font = [UIFont systemFontOfSize:13];
    forgetButton.titleLabel.textAlignment = NSTextAlignmentRight;
    [forgetButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [forgetButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [forgetButton setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [forgetButton addTarget:self action:@selector(forgetPassword:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetButton];
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(220, kScreenHeight - 64 - 30, 80, 20)];
    versionLabel.backgroundColor = [UIColor clearColor];
    versionLabel.textColor = [UIColor lightGrayColor];
    versionLabel.font = [UIFont systemFontOfSize:12];
    versionLabel.text = [NSString stringWithFormat:@"版本号 %@",version];
    [self.view addSubview:versionLabel];
}

- (void)setValueForUI {
    FXLoginUser *user = [FXArchiverHelper getUserPassword];
    if (user) {
        _usernameField.text = user.username;
        _passwordField.text = user.password;
    }
}

#pragma mark - Action

- (IBAction)userLogin:(id)sender {
    [(UIButton *)sender setUserInteractionEnabled:NO];
    [_usernameField resignFirstResponder];
    [_passwordField resignFirstResponder];
    [self resetViewFrame];
    if ([_usernameField.text isEqualToString:@""] || [_passwordField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"用户名或密码不能为空！"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        [(UIButton *)sender setUserInteractionEnabled:YES];
        return;
    }
    else {
        [FXAppDelegate addHUDForView:self.view animate:YES];
        [FXRequestDataFormat
         authenticationInWithUsername:_usernameField.text
         Password:_passwordField.text
         Finished:^(BOOL success, NSData *response) {
             [FXAppDelegate hideHUDForView:self.view animate:YES];
             [(UIButton *)sender setUserInteractionEnabled:YES];
             if (success) {
                 AuthenticationResponse *resp = [AuthenticationResponse parseFromData:response];
                 if (resp.isSucceed) {
                     //正确
                     [self loginSuccessWithUserID:resp.userId token:resp.token];
                 }
                 else {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                                     message:@"用户名或密码不正确！"
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                     [alert show];
                 }
                 NSLog(@"%d,%d,%@",resp.isSucceed,resp.userId,resp.token);
             }
             else {
                 NSLog(@"auth fail :%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
             }
         }];
    }
}

- (void)loginSuccessWithUserID:(int32_t)userid token:(NSString *)loginToken {
    FXAppDelegate *delegate = [FXAppDelegate shareFXAppDelegate];
    delegate.userID = userid;
    delegate.token = loginToken;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *messageTimeStamp = [NSString stringWithFormat:@"%d_messageTimeStamp",delegate.userID];
    NSString *contactTimeStamp = [NSString stringWithFormat:@"%d_contactTimeStamp",delegate.userID];
    delegate.messageTimeStamp = [defaults objectForKey:messageTimeStamp];
    delegate.contactTimeStamp = [defaults objectForKey:contactTimeStamp];
    //数据库操作保存id
    [SharedClass sharedObject].userID = [NSString stringWithFormat:@"%d",userid];
    
    NSLog(@"!!%@",delegate.push_deviceToken);
    [self getUserInfo];
    //保存用户信息
    FXLoginUser *loginUser = [[FXLoginUser alloc] init];
    loginUser.username = _usernameField.text;
    loginUser.password = _passwordField.text;
    [FXArchiverHelper saveUserPassword:loginUser];
    
    [self setPushInfo];
    
    FXRootViewController *rootController = [[FXAppDelegate shareFXAppDelegate] shareRootViewContorller];
    [rootController showMainViewController];
}

- (void)setPushInfo {
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
                           setIsPushEnable:YES] build];
    [FXRequestDataFormat clientInfoWithToken:delegate.token UserID:delegate.userID Client:client Finished:^(BOOL success, NSData *response) {
        if (success) {
            //请求成功
            ClientInfoResponse *resp = [ClientInfoResponse parseFromData:response];
            if (resp.isSucceed) {
                //接收成功
                delegate.enablePush = YES;
                NSLog(@"push success");
            }
            else {
                //接收失败
                NSLog(@"push = %d",resp.errorCode);
            }
        }
    }];
}

- (IBAction)userRegister:(id)sender {
    FXRegisterController *registerC = [[FXRegisterController alloc] init];
    [self.navigationController pushViewController:registerC animated:YES];
}

- (IBAction)forgetPassword:(id)sender {
    FXForgotPasswordController *forgotPWDController = [[FXForgotPasswordController alloc] initWithNibName:@"FXForgotPasswordController" bundle:nil];
    [self.navigationController pushViewController:forgotPWDController animated:YES];
}

- (void)getUserInfo {
    [self getUserInfoWithLogin:YES];
}

//从本地读取此用户是否曾登录过
- (void)getUserInfoWithLogin:(BOOL)needLogin {
    FXUserModel *user = [FXArchiverHelper getUserInfoWithLoginName:_usernameField.text];
    if (user) {
        if (needLogin) {
            FXAppDelegate *delegate = [FXAppDelegate shareFXAppDelegate];
            delegate.user = user;
        }
        if (user.tile && [user.tile length] > 0) {
            _userView.userPhotoView.image = [UIImage imageWithData:user.tile];
        }
    }
    else {
        _userView.userPhotoView.image = [UIImage imageNamed:@"placeholder.png"];
        FXAppDelegate *delegate = [FXAppDelegate shareFXAppDelegate];
        delegate.user = nil;
    }
}

#pragma mark - UITextFieldDelegate 

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self resetViewFrame];
    return YES;
}

#pragma mark - Keyboard

- (void)keyboardWillShow:(NSNotification *)notification {
    if (([_usernameField isFirstResponder] || [_passwordField isFirstResponder]) && !_isMove) {
        _isMove = YES;
        NSDictionary *info = [notification userInfo];
        CGRect kbRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        //308为登录按钮最低端
        int offset = 308 - (kScreenHeight - 64 - kbRect.size.height);
        if (offset > 0) {
            [UIView animateWithDuration:0.3 animations:^{
                CGRect rect = self.view.frame;
                rect.origin.y -= offset;
                self.view.frame = rect;
            }];
        }
    }
}

- (void)resetViewFrame {
    _isMove = NO;
    [UIView animateWithDuration:0.3 animations:^{
        CGFloat originY = 0;
        if (kDeviceVersion >= 7.0) {
            originY = 64;
        }
        CGRect rect = CGRectMake(0, originY, self.view.frame.size.width, self.view.frame.size.height);
        self.view.frame = rect;
    }];
}

@end
