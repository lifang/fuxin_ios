//
//  FXLoginController.m
//  FuXin
//
//  Created by 徐宝桥 on 14-5-14.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXLoginController.h"
#import "FXRegisterController.h"
#import "FXAppDelegate.h"
#import "LHLDBTools.h"
#import "SharedClass.h"

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
    FXRootViewController *rootController = [[FXAppDelegate shareFXAppDelegate] shareRootViewContorller];
    [rootController showMainViewController];
}

- (IBAction)userRegister:(id)sender {
    FXRegisterController *registerC = [[FXRegisterController alloc] init];
    [self.navigationController pushViewController:registerC animated:YES];
}

- (IBAction)forgetPassword:(id)sender {
    
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
    __block NSMutableArray *contacts = [NSMutableArray array];
//    ContactModel *contact;
//    for (int i = 0; i < 10000; i ++) {
//        contact = [[ContactModel alloc] init];
//        contact.contactID = [NSString stringWithFormat:@"%d",i];
//        contact.contactNickname = [NSString stringWithFormat:@"doggie_%d",100000 - i];
//        contact.contactSex = i % 2;
//        [contacts addObject:contact];
//    }
    
    NSLog(@"开始");
    [LHLDBTools getAllContactsWithFinished:^(NSArray *contactsArray, NSString *errorMessage) {
        contacts = [NSMutableArray arrayWithArray:contactsArray];
    }];
//    [LHLDBTools deleteContact:contacts withFinished:^(BOOL flag) {
//        
//    }];
    NSLog(@"结束");
    
}

@end
