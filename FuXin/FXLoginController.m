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

@interface FXLoginController ()<UITextFieldDelegate>
//@property (assign ,nonatomic) NSTimeInterval seconds;
@end

@implementation FXLoginController

@synthesize userView = _userView;
@synthesize usernameField = _usernameField;
@synthesize passwordField = _passwordField;

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
    self.title = @"福务网";
    self.view.backgroundColor = kColor(250, 250, 250, 1);
    [self initUI];
    
    [self testDBMethod];
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
}

- (void)setUserNameAndPasswordUI {
    //用户名框
    UIView *userBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    UIImageView *userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    userImageView.image = [UIImage imageNamed:@"username.png"];
    [userBackView addSubview:userImageView];
    _usernameField = [[UITextField alloc] initWithFrame:CGRectMake(30, 115, 260, 36)];
    _usernameField.returnKeyType = UIReturnKeyDone;
    _usernameField.text = @"MockUserName";
    _usernameField.borderStyle = UITextBorderStyleNone;
    _usernameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _usernameField.leftViewMode = UITextFieldViewModeAlways;
    _usernameField.leftView = userBackView;
    _usernameField.delegate = self;
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
    _passwordField.text = @"12";
    _passwordField.borderStyle = UITextBorderStyleNone;
    _passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passwordField.leftViewMode = UITextFieldViewModeAlways;
    _passwordField.leftView = psdBackView;
    _passwordField.delegate = self;
    [self.view addSubview:_passwordField];
    //划线
    rect = _passwordField.frame;
    UIView *psdLinsView = [[UIView alloc] initWithFrame:CGRectMake(rect.origin.x, rect.origin.y + rect.size.height + 1, rect.size.width, 1)];
    psdLinsView.backgroundColor = kColor(209, 27, 33, 0.3);
    [self.view addSubview:psdLinsView];
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
    registerButton.frame = CGRectMake(40, 320, 80, 20);
    registerButton.titleLabel.font = [UIFont systemFontOfSize:13];
    registerButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [registerButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [registerButton setTitle:@"立即注册" forState:UIControlStateNormal];
    [registerButton addTarget:self action:@selector(userRegister:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerButton];
    //忘记密码
    UIButton *forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetButton.frame = CGRectMake(200, 320, 80, 20);
    forgetButton.titleLabel.font = [UIFont systemFontOfSize:13];
    forgetButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [forgetButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [forgetButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [forgetButton setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [forgetButton addTarget:self action:@selector(forgetPassword:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetButton];
}

#pragma mark - Action

- (IBAction)userLogin:(id)sender {
    [_usernameField resignFirstResponder];
    [_passwordField resignFirstResponder];
    if ([_usernameField.text isEqualToString:@""] || [_passwordField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"用户名或密码不能为空！"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    else {
        [FXRequestDataFormat
         authenticationInWithUsername:_usernameField.text
         Password:_passwordField.text
         Finished:^(BOOL success, NSData *response) {
             if (success) {
                 AuthenticationResponse *resp = [AuthenticationResponse parseFromData:response];
                 if (resp.isSucceed) {
                     //正确
                     FXAppDelegate *delegate = [FXAppDelegate shareFXAppDelegate];
                     delegate.userID = resp.userId;
                     delegate.token = resp.token;
                     
                     FXRootViewController *rootController = [[FXAppDelegate shareFXAppDelegate] shareRootViewContorller];
                     [rootController showMainViewController];
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

- (IBAction)userRegister:(id)sender {
    FXRegisterController *registerC = [[FXRegisterController alloc] init];
    [self.navigationController pushViewController:registerC animated:YES];
}

- (IBAction)forgetPassword:(id)sender {
    FXForgotPasswordController *forgotPWDController = [[FXForgotPasswordController alloc] initWithNibName:@"FXForgotPasswordController" bundle:nil];
    [self.navigationController pushViewController:forgotPWDController animated:YES];
}

#pragma mark - UITextFieldDelegate 

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark 测试方法 -----------------------------
- (void)testDBMethod{
    [SharedClass sharedObject].userID = @"813";
    //测试按钮
    UIButton *forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetButton.frame = CGRectMake(120, 320, 80, 20);
    forgetButton.titleLabel.font = [UIFont systemFontOfSize:13];
    forgetButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [forgetButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [forgetButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [forgetButton setBackgroundColor:[UIColor blueColor]];
    [forgetButton setTitle:@"测试功能？" forState:UIControlStateNormal];
    [forgetButton addTarget:self action:@selector(testButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetButton];
    
}

- (void)testButton:(id)sender{
    __block NSMutableArray *dataArray = [NSMutableArray array];
    MessageModel *msg;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss .SSS"];
    for (int i = 10000; i < 90000; i ++) {
        msg = [[MessageModel alloc] init];
        msg.messageRecieverID = [NSString stringWithFormat:@"%d" ,i % 7 ];
        msg.messageSendTime = [formatter stringFromDate:[NSDate date]];
        msg.messageContent = @"一二三四五 ,上山打老虎 ,老虎没打着 ,打着小松鼠 .";
        if (i % 6 == 0) {
            msg.messageContent = @"一二三四五 ,上山打老虎 ,老虎没打着 ,打着小松鼠 .一二三四五 ,上山打老虎 ,老虎没打着 ,打着小松鼠 .一二三四五 ,上山打老虎 ,老虎没打着 ,打着小松鼠 .一二三四五 ,上山打老虎 ,老虎没打着 ,打着小松鼠 .一二三四五 ,上山打老虎 ,老虎没打着 ,打着小松鼠 .一二三四五 ,上山打老虎 ,老虎没打着 ,打着小松鼠 .一二三四五 ,上山打老虎 ,老虎没打着 ,打着小松鼠 .一二三四五 ,上山打老虎 ,老虎没打着 ,打着小松鼠 .一二三四五 ,上山打老虎 ,老虎没打着 ,打着小松鼠 .";
        }
        msg.messageAttachment = [NSString stringWithFormat:@"img/photo_2014_200%d", i];
        msg.messageStatus = (MessageStatus)(i % 4 + 1);
        
        [dataArray addObject:msg];
    }
    
    [LHLDBTools shareLHLDBTools];
    NSLog(@"开始");
    [LHLDBTools saveChattingRecord:dataArray withFinished:^(BOOL flag) {
        
    }];
    NSLog(@"11");
    [LHLDBTools deleteChattingRecordsWithContactID:@"3" withFinished:^(BOOL flag) {   //慢 一秒
        
    }];
    NSLog(@"删除成功");
    __block NSInteger number = 0;
    [LHLDBTools numberOfUnreadChattingRecordsWithContactID:@"1" withFinished:^(NSInteger quantity, NSString *errorMessage) {
        number = quantity ;
    }];
    NSLog(@"未读聊天记录有: %ld 条 ,我们来更新一下",(long)number);
    [LHLDBTools clearUnreadStatusWithContactID:@"1" withFinished:^(BOOL flag) {    //慢 0.9秒
        
    }];
    NSLog(@"44");
    [LHLDBTools numberOfUnreadChattingRecordsWithContactID:@"1" withFinished:^(NSInteger quantity, NSString *errorMessage) {
        number = quantity ;
    }];
    NSLog(@"未读聊天记录有: %ld 条 ",(long)number);
    NSLog(@"结束");
//    for (MessageModel *obj in resultArray){
//        NSLog(@"%@-%@-%@",obj.messageSendTime ,obj.messageAttachment ,obj.messageRecieverID);
//    }
    
}

@end
