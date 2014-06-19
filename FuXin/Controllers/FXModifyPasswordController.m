//
//  FXModifyPasswordController.m
//  FuXin
//
//  Created by lihongliang on 14-6-3.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXModifyPasswordController.h"

#define kBlank_Size 15   //边缘空白
#define kCell_Height 44
#define kReSendTime 180  //重发验证码间隔
#define kIdentifyingCodeTime 300   //验证码有效期

@interface FXModifyPasswordController ()<UIAlertViewDelegate>
//控件区
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UITextField *passwordTextField;   //密码
@property (strong, nonatomic) UILabel *passwordTipLabel;  //密码输入提示
@property (strong, nonatomic) UITextField *confirmPasswordTextField;  //确认密码
@property (strong, nonatomic) UILabel *tipLabel;   //提示信息
@property (strong, nonatomic) UILabel *coundDownLabel;   //验证码倒计时
@property (strong, nonatomic) UITextField *phoneNumberTextField;  //电话号码
@property (strong, nonatomic) UITextField *identifyingCodeTextField;  //验证码
@property (strong, nonatomic) UILabel *alertLabel;   //电话号码错误警示
@property (strong, nonatomic) UILabel *alertIdentiyingLabel;   //验证码错误警示
@property (strong, nonatomic) UIButton *rewriteButton;   //重填电话号码
@property (strong, nonatomic) UIButton *reSendButton;    //重发验证码
@property (strong, nonatomic) UIButton *doneButton;   //完成按钮
@property (strong, nonatomic) UITextField *originPasswordTextField;  //原密码
@property (strong, nonatomic) UILabel *originPasswordTipLabel; //原密码提示
@property (strong, nonatomic) UIView *footerView; //用来放置doneButton
@property (strong, nonatomic) UIView *lineView; //一条线

- (IBAction)spaceAreaClicked:(id)sender;

//数据区
@property (strong, nonatomic) NSString *phoneNumberString; //真实电话号码
@property (assign, nonatomic) BOOL originPasswordIsOK; //用户名无问题
@property (assign, nonatomic) BOOL passwordIsOK; //密码无问题
@property (assign, nonatomic) BOOL identiCodeIsOK;  //验证码OK
@property (assign, nonatomic) BOOL phoneNumberIsOK; //手机号码格式OK

//其他
@property (strong ,nonatomic) NSTimer *inputAlertTimer; //输入1秒后提示timer
@property (strong ,nonatomic) NSTimer *reSendTimer;   //重发验证码timer
@property (strong ,nonatomic) NSTimer *identtifyingCodeTimer;  //验证码有效期timer
@property (strong ,nonatomic) NSTimer *timingTimer;  //计时timer

//保存服务器返回的验证码
@property (nonatomic, strong) NSString *validateString;

@end

@implementation FXModifyPasswordController

@synthesize validateString = _validateString;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setLeftNavBarItemWithImageName:@"back.png"];
    
    [self initViews];
    
    self.timingTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timingTimerFired:) userInfo:nil repeats:YES];
    self.passwordIsOK = NO;
    self.identiCodeIsOK = NO;
    self.originPasswordIsOK = NO;
    self.phoneNumberIsOK = NO;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(spaceAreaClicked:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    self.title = @"修改密码";
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDismissNotification:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDismissNotification:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

//各种控件初始化
- (void)initViews{
    self.view.backgroundColor = kColor(250, 250, 250, 1);
    
    UITextField *originPasswordField = [[UITextField alloc] init];
    originPasswordField.placeholder = @"输入原密码";
    originPasswordField.keyboardType = UIKeyboardTypeDefault;
    originPasswordField.secureTextEntry = YES;
    originPasswordField.returnKeyType = UIReturnKeyNext;
    originPasswordField.textColor = kColor(51, 51, 51, 1);
    originPasswordField.font = [UIFont systemFontOfSize:14.];
    originPasswordField.delegate = self;
    originPasswordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    originPasswordField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.originPasswordTextField = originPasswordField;
    
    UILabel *originPasswordTip = [[UILabel alloc] init];
    originPasswordTip.font = [UIFont systemFontOfSize:12.];
    originPasswordTip.textColor = kColor(255, 0, 9, 1);
    originPasswordTip.textAlignment = NSTextAlignmentRight;
    originPasswordTip.backgroundColor = [UIColor clearColor];
    self.originPasswordTipLabel = originPasswordTip;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(kBlank_Size, 0, 290, 300) style:UITableViewStylePlain];
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor clearColor];
    if (kDeviceVersion >= 7.0) {
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    self.tableView.separatorColor = kColor(191, 191, 191, 1);
    
    self.passwordTipLabel = [[UILabel alloc] init];
    self.passwordTipLabel.font = [UIFont systemFontOfSize:12.];
    self.passwordTipLabel.textAlignment = NSTextAlignmentRight;
    _passwordTipLabel.backgroundColor = [UIColor clearColor];
    self.passwordTipLabel.textColor = kColor(255, 0, 9, 1);
    
    self.alertLabel = [[UILabel alloc] init];
    self.alertLabel.textAlignment = NSTextAlignmentRight;
    self.alertLabel.font = [UIFont systemFontOfSize:12.];
    self.alertLabel.textColor = kColor(255, 0, 9, 1);
    _alertLabel.backgroundColor = [UIColor clearColor];
    
    self.alertIdentiyingLabel = [[UILabel alloc] init];
    self.alertIdentiyingLabel.font = [UIFont systemFontOfSize:12.];
    self.alertIdentiyingLabel.textAlignment = NSTextAlignmentRight;
    _alertIdentiyingLabel.backgroundColor = [UIColor clearColor];
    self.alertIdentiyingLabel.textColor = kColor(255, 0, 9, 1);
    
    self.passwordTextField = [[UITextField alloc] init];
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.placeholder = @"输入密码";
    self.passwordTextField.keyboardType = UIKeyboardTypeASCIICapable;
    self.passwordTextField.returnKeyType = UIReturnKeyNext;
    self.passwordTextField.textColor = kColor(51, 51, 51, 1);
    _passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _passwordTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.passwordTextField.font = [UIFont systemFontOfSize:14.];
    self.passwordTextField.delegate = self;
    
    self.confirmPasswordTextField = [[UITextField alloc] init];
    self.confirmPasswordTextField.secureTextEntry = YES;
    self.confirmPasswordTextField.placeholder = @"确认密码";
    self.confirmPasswordTextField.keyboardType = UIKeyboardTypeASCIICapable;
    self.confirmPasswordTextField.returnKeyType = UIReturnKeyNext;
    _confirmPasswordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _confirmPasswordTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.confirmPasswordTextField.textColor = kColor(51, 51, 51, 1);
    self.confirmPasswordTextField.font = [UIFont systemFontOfSize:14.];
    self.confirmPasswordTextField.delegate = self;
    
    self.phoneNumberTextField = [[UITextField alloc] init];
    self.phoneNumberTextField.textColor = kColor(51, 51, 51, 1);
    self.phoneNumberTextField.placeholder = @"电话号码";
    self.phoneNumberTextField.delegate = self;
    self.phoneNumberTextField.font = [UIFont systemFontOfSize:14.];
    self.phoneNumberTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _phoneNumberTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _phoneNumberTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.phoneNumberTextField.returnKeyType = UIReturnKeyNext;
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = kColor(191, 191, 191, 1);
    
    self.rewriteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self changeRewriteButtonStatus:NO];
    [self.rewriteButton setTitle:@"确认" forState:UIControlStateNormal];
    self.rewriteButton.layer.cornerRadius = 6.;
    self.rewriteButton.layer.borderWidth = .7;
    self.rewriteButton.titleLabel.font = [UIFont systemFontOfSize:13.];
    [self.rewriteButton addTarget:self action:@selector(rewriteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.identifyingCodeTextField = [[UITextField alloc] init];
    self.identifyingCodeTextField.textColor = kColor(51, 51, 51, 1);
    self.identifyingCodeTextField.font = [UIFont systemFontOfSize:14.];
    self.identifyingCodeTextField.placeholder = @"输入验证码";
    self.identifyingCodeTextField.delegate = self;
    _identifyingCodeTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _identifyingCodeTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.identifyingCodeTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    self.identifyingCodeTextField.returnKeyType = UIReturnKeyDone;
    UIView *inputAccessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, kCell_Height)];
    inputAccessoryView.backgroundColor = [UIColor clearColor];
    self.identifyingCodeTextField.inputAccessoryView = inputAccessoryView;
    
    self.tipLabel = [[UILabel alloc] init];
    self.tipLabel.font = [UIFont systemFontOfSize:12.];
    self.tipLabel.text = @"确认手机号码之后发送验证码";
    _tipLabel.backgroundColor = [UIColor clearColor];
    self.tipLabel.textColor = kColor(191, 191, 191, 1);
    
    self.coundDownLabel = [[UILabel alloc] init];
    self.coundDownLabel.font = [UIFont systemFontOfSize:12.];
    _coundDownLabel.backgroundColor = [UIColor clearColor];
    self.coundDownLabel.textColor = kColor(191, 191, 191, 1);
    
    self.reSendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self changeReSendButtonStatus:NO];
    [self.reSendButton setTitle:@"重新发送" forState:UIControlStateNormal];
    self.reSendButton.layer.cornerRadius = 6.;
    self.reSendButton.layer.borderWidth = .7;
    self.reSendButton.titleLabel.font = [UIFont systemFontOfSize:13.];
    [self.reSendButton addTarget:self action:@selector(reSendButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.doneButton.layer.cornerRadius = 4.;
    self.doneButton.backgroundColor = kColor(209, 27, 33, 1);
    [self.doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [self.doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [self.doneButton addTarget:self action:@selector(doneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.doneButton];
    [self changeDoneButtonStatus];
    
    _footerView = [[UIView alloc] init];
    _footerView.frame = CGRectMake(0, 0, 320 - 2 * kBlank_Size, [UIScreen mainScreen].bounds.size.height - 6 * kCell_Height - 44 - 51);
    [_footerView addSubview:_doneButton];
    _footerView.backgroundColor = self.view.backgroundColor;
    _doneButton.frame = (CGRect){0 ,0 ,self.view.frame.size.width - 2 * kBlank_Size ,kCell_Height};
    _doneButton.center = CGPointMake(_footerView.frame.size.width / 2, _footerView.frame.size.height - _doneButton.frame.size.height / 2 - 30);
    _tableView.tableFooterView = _footerView;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, kBlank_Size)];
    headerView.backgroundColor = self.view.backgroundColor;
    _tableView.tableHeaderView = headerView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //table边缘有30像素的白边
    self.tableView.frame = (CGRect){kBlank_Size ,0 ,self.view.frame.size.width - 2 * kBlank_Size ,self.view.frame.size.height};
    
}

- (void)viewDidAppear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"changePassword"];
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"changePassword"];
}
- (void)back:(id)sender{
    [self.inputAlertTimer invalidate];
    [self.reSendTimer invalidate];
    [self.timingTimer invalidate];
    [self.identtifyingCodeTimer invalidate];
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // 每行 高度88 边缘 30  text起头 10
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableView Datasource && delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 180, 0);
    
    return kCell_Height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.backgroundColor = [UIColor clearColor];
    CGSize cellSize = CGSizeMake(290, kCell_Height);
    switch (indexPath.row) {
        case 0:
            if ([self cell:cell isNotSuperOfView:self.originPasswordTextField]) {
                self.originPasswordTextField.frame = (CGRect){10 ,0 ,2 * cellSize.width / 3 ,cellSize.height};
                [cell.contentView addSubview:self.originPasswordTextField];
            }
            if ([self cell:cell isNotSuperOfView:self.originPasswordTipLabel]) {
                self.originPasswordTipLabel.frame = (CGRect){(cellSize.width * 4 / 5) - 10 ,0 ,cellSize.width / 5 ,cellSize.height};
                [cell.contentView addSubview:self.originPasswordTipLabel];
            }
            break;
        case 1:  //密码
            if ([self cell:cell isNotSuperOfView:self.passwordTextField]) {
                self.passwordTextField.frame = (CGRect){10 ,0 ,cellSize.width * 3 / 4 - 20 ,cellSize.height};
                [cell.contentView addSubview:self.passwordTextField];
            }
            break;
        case 2:   //确认密码
            if ([self cell:cell isNotSuperOfView:self.confirmPasswordTextField]) {
                self.confirmPasswordTextField.frame = (CGRect){10 ,0 ,cellSize.width * 3 / 4 - 20 ,cellSize.height};
                [cell.contentView addSubview:self.confirmPasswordTextField];
            }
            if ([self cell:cell isNotSuperOfView:self.passwordTipLabel]) { //密码输入提示
                self.passwordTipLabel.frame = (CGRect){cellSize.width - 10 - cellSize.width / 4 ,0 ,cellSize.width / 4 ,cellSize.height};
                [cell.contentView addSubview:self.passwordTipLabel];
            }
            break;
        case 3: {   //电话号码
            if ([self cell:cell isNotSuperOfView:self.phoneNumberTextField]) {
                self.phoneNumberTextField.frame = (CGRect){10 ,0 ,cellSize.width / 2 ,cellSize.height};
                [cell.contentView addSubview:self.phoneNumberTextField];
            }
            if ([self cell:cell isNotSuperOfView:self.rewriteButton]) {   //重填电话号码
                CGFloat buttonWidth = 60;
                self.rewriteButton.frame = (CGRect){cellSize.width - 10 - buttonWidth ,7 ,buttonWidth ,cellSize.height - 14};
                [cell.contentView addSubview:self.rewriteButton];
            }
            if ([self cell:cell isNotSuperOfView:self.alertLabel]) {        //电话号码错误警示
                self.alertLabel.frame = (CGRect){CGRectGetMinX(self.rewriteButton.frame) - 5 - cellSize.width / 4 ,0 ,cellSize.width / 4 ,cellSize.height};
                [cell.contentView addSubview:self.alertLabel];
            }
            if ([self cell:cell isNotSuperOfView:self.lineView]) {
                self.lineView.frame = (CGRect){0 ,0 ,cellSize.width ,2};
                [cell.contentView addSubview:self.lineView];
            }
        }
            break;
        case 4:    //验证码
            if ([self cell:cell isNotSuperOfView:self.identifyingCodeTextField]) {
                self.identifyingCodeTextField.frame = (CGRect){10 ,0 ,cellSize.width / 3 ,cellSize.height};
                [cell.contentView addSubview:self.identifyingCodeTextField];
            }
            if ([self cell:cell isNotSuperOfView:self.reSendButton]) {  //重发验证码
                CGFloat buttonWidth = 60;
                self.reSendButton.frame = (CGRect){cellSize.width - 10 - buttonWidth ,7 ,buttonWidth ,cellSize.height - 14};
                [cell.contentView addSubview:self.reSendButton];
            }
            if ([self cell:cell isNotSuperOfView:self.alertIdentiyingLabel]) {      //验证码错误警示
                self.alertIdentiyingLabel.frame = (CGRect){CGRectGetMinX(self.reSendButton.frame) - 5 - cellSize.width / 4 ,0 ,cellSize.width / 4 ,cellSize.height};
                [cell.contentView addSubview:self.alertIdentiyingLabel];
            }
            break;
        case 5:    //提示信息
            if ([self cell:cell isNotSuperOfView:self.tipLabel]) {
                self.tipLabel.frame = (CGRect){10 ,0 ,2 * cellSize.width / 3 ,cellSize.height};
                [cell.contentView addSubview:self.tipLabel];
            }
//            if ([self cell:cell isNotSuperOfView:self.coundDownLabel]) {   //验证码倒计时
//                self.coundDownLabel.frame = (CGRect){(cellSize.width * 3 / 4) - 10 ,0 ,cellSize.width / 4 ,cellSize.height};
//                [cell.contentView addSubview:self.coundDownLabel];
//            }
            break;
        default:
            break;
    }
    return cell;
}

//判断一个cell不是某控件的superView
- (BOOL)cell:(UITableViewCell *)cell isNotSuperOfView:(UIView *)view{
    BOOL flag = YES;
    for (UIView *subview in cell.subviews){
        if (subview == view) {
            flag = NO;
        }
    }
    return flag;
}

#pragma mark UITextField delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //输入一秒后提示
    [self.inputAlertTimer invalidate];
    self.inputAlertTimer = [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(timerFired:) userInfo:@{@"textField": textField} repeats:NO];
    
    if ([string isEqualToString:@"\n"]) {
        if (textField == self.passwordTextField) {
            [self.confirmPasswordTextField becomeFirstResponder];
        }else if (textField == self.confirmPasswordTextField){
            if (self.phoneNumberTextField.enabled) {
                [self.phoneNumberTextField becomeFirstResponder];
            }else{
                [textField resignFirstResponder];
            }
            
        }else if (textField == self.phoneNumberTextField){
            [self.identifyingCodeTextField becomeFirstResponder];
        }else if (textField == self.identifyingCodeTextField){
            [textField resignFirstResponder];
        }else if (textField == self.originPasswordTextField){
            [self.passwordTextField becomeFirstResponder];
        }
        return NO;
    }
    
    if ([string isEqualToString:@""]) {
        return YES;
    }
    
    //密码长度限制
    if (textField == self.passwordTextField || textField == self.confirmPasswordTextField) {
        if ([string isEqualToString:@""]) {
            return YES;
        }else{
            if (textField.text.length + string.length > 20) {
                return NO;
            }
        }
        
    }
    
    if (textField == self.phoneNumberTextField) {  //电话号码特殊格式
        if (string.length == 1){
            if ([string characterAtIndex:0] >= '0' &&  [string characterAtIndex:0] <= '9') {
                if (self.phoneNumberTextField.text.length == 3 || self.phoneNumberTextField.text.length == 8) {
                    self.phoneNumberTextField.text = [NSString stringWithFormat:@"%@ %@",self.phoneNumberTextField.text, string];
                    return NO;
                }
                if (self.phoneNumberTextField.text.length == 13) {
                    return NO;
                }
                return YES;
            }else{
                return NO;
            }
        }
    }
    
    if (textField == self.identifyingCodeTextField) {
        if (string.length == 1){
            if ([string characterAtIndex:0] >= '0' &&  [string characterAtIndex:0] <= '9') {
                if (self.identifyingCodeTextField.text.length >= 6) {
                    return NO;
                }
                return YES;
            }else{
                return NO;
            }
        }
    }
    
    if (textField == self.originPasswordTextField) {
        //长度小于15
        if (textField.text.length + string.length > 20) {
            return NO;
        }
    }
    
    return YES;
}

//选中验证码框时, 界面上移
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == self.identifyingCodeTextField) {
        [self doneButtonMoveToKeyboard];
        [UIView animateWithDuration:.2 animations:^{
            self.tableView.contentOffset = CGPointMake(0, is4Inch(80, 120));
        }];
    }else{
        [self doneButtonMoveToFooter];
    }
    return YES;
}

#pragma mark 控件响应
- (void)spaceAreaClicked:(id)sender {
    [self.passwordTextField resignFirstResponder];
    [self.confirmPasswordTextField resignFirstResponder];
    [self.phoneNumberTextField resignFirstResponder];
    [self.identifyingCodeTextField resignFirstResponder];
}

//验证码获取成功
- (void)getValidateSuccessWithButton:(UIButton *)sender {
    UIView *superView = [sender superview];
    //1,开始计时
    [self changeReSendButtonStatus:NO];
    if (self.reSendTimer) {
        [self.reSendTimer invalidate];
    }
    self.reSendTimer = [NSTimer scheduledTimerWithTimeInterval:kReSendTime target:self selector:@selector(reSendTimerFired:) userInfo:nil repeats:NO];
    if (self.identtifyingCodeTimer) {
        [self.identtifyingCodeTimer invalidate];
    }
    self.identtifyingCodeTimer = [NSTimer scheduledTimerWithTimeInterval:kIdentifyingCodeTime target:self selector:@selector(identifyingCodeTimerFired:) userInfo:nil repeats:NO];
    
    //2 ,修改界面
    [sender setTitle:@"重填" forState:UIControlStateNormal];
    self.tipLabel.text = @"验证码已发送至您的手机";
    superView.backgroundColor = kColor(241, 241, 241, 1);
    self.phoneNumberTextField.enabled = NO;
    self.phoneNumberTextField.textColor = kColor(135, 135, 135, 1);
    [self.identifyingCodeTextField becomeFirstResponder];
}

//点击重发验证码按钮
- (void)reSendButtonClicked:(UIButton *)sender{
    [self changeReSendButtonStatus:NO];
    if (self.reSendTimer) {
        [self.reSendTimer invalidate];
    }
    self.reSendTimer = [NSTimer scheduledTimerWithTimeInterval:kReSendTime target:self selector:@selector(reSendTimerFired:) userInfo:nil repeats:NO];
    if (self.identtifyingCodeTimer) {
        [self.identtifyingCodeTimer invalidate];
    }
    self.identtifyingCodeTimer = [NSTimer scheduledTimerWithTimeInterval:kIdentifyingCodeTime target:self selector:@selector(identifyingCodeTimerFired:) userInfo:nil repeats:NO];
    [self confirmPhoneNuber:self.rewriteButton];
}

//点击电话号码按钮
- (void)rewriteButtonClicked:(UIButton *)sender{
    UIView *superView = [sender superview];
    if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"确认"]) {
        [self confirmPhoneNuber:sender];
    }else if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"重填"]){
        self.phoneNumberTextField.text = @"";
        [self.reSendTimer invalidate];
        [self.identtifyingCodeTimer invalidate];
        
        [sender setTitle:@"确认" forState:UIControlStateNormal];
        superView.backgroundColor = [UIColor clearColor];
        self.phoneNumberTextField.enabled = YES;
        self.phoneNumberTextField.textColor = kColor(51, 51, 51, 1);
        
        [self changeReSendButtonStatus:NO];
        [self changeRewriteButtonStatus:NO];
    }
}

//确认电话号码, 发送短信
- (void)confirmPhoneNuber:(UIButton *)sender{
    NSMutableString *phoneNumberString = [NSMutableString stringWithString:self.phoneNumberTextField.text];
    [phoneNumberString replaceOccurrencesOfString:@" " withString:@"" options:0 range:NSMakeRange(0, phoneNumberString.length)];
    [FXAppDelegate addHUDForView:self.view animate:YES];
    [FXRequestDataFormat validateCodeWithPhoneNumber:phoneNumberString
                                                Type:ValidateCodeRequest_ValidateTypeChangePassword
                                            Finished:^(BOOL success, NSData *response) {
                                                [FXAppDelegate hideHUDForView:self.view animate:YES];
                                                if (success) {
                                                    //请求成功
                                                    ValidateCodeResponse *resp = [ValidateCodeResponse parseFromData:response];
                                                    NSLog(@"%d,%d",resp.isSucceed,resp.errorCode);
                                                    if (resp.isSucceed) {
                                                        //获取验证码成功
                                                        NSLog(@"validate = %d",resp.errorCode);
                                                        [self getValidateSuccessWithButton:sender];
                                                    }
                                                    else {
                                                        //获取失败
                                                        NSString *errorInfo = [self showErrorInfoWithType:resp.errorCode];
                                                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                                                                            message:errorInfo
                                                                                                           delegate:nil
                                                                                                  cancelButtonTitle:@"确定"
                                                                                                  otherButtonTitles:nil];
                                                        [alertView show];
                                                    }
                                                }
                                                else {
                                                    //请求失败
                                                    NSLog(@"validate fail");
                                                }
                                            }];
}

- (NSString *)showErrorInfoWithType:(int)type {
    NSString *info = nil;
    switch (type) {
        case 1:
            info = @"序列化参数出错！";
            break;
        case 2:
            info = @"手机号码有误,请重新输入！";
            break;
        case 3:
            info = @"发送类型有误！";
            break;
        case 4:
            info = @"用户已存在！";
            break;
        case 5:
            info = @"用户不存在！";
            break;
        case 6:
            info = @"暂不能重复发送验证码,请稍后再试！";
            break;
        case 7:
            info = @"短信服务出错,发送失败!";
            break;
        default:
            break;
    }
    return info;
}

///转换请求错误文本
- (NSString *)showErrorInfoWithResetPasswordErrorType:(int)type {
    NSString *info;
    switch (type) {
        case 1:
            info = @"序列化参数出错";
            break;
        case 2:
            info = @"用户账户有误!";
            break;
        case 3:
            info = @"Token参数有误!";
            break;
        case 4:
            info = @"身份验证失败!";
            break;
        case 5:
            info = @"数据库连接错误!";
            break;
        case 6:
            info = @"用户不存在!";
            break;
        case 7:
            info = @"旧密码有误!";
            break;
        case 8:
            info = @"新密码有误!";
            break;
        case 9:
            info = @"确认密码有误!";
            break;
        case 10:
            info = @"确认密码不一致!";
            break;
        case 11:
            info = @"验证码有误!";
            break;
        default:
            break;
    }
    return info;
}

//完成
- (void)doneButtonClicked:(UIButton *)sender{
    [(UIButton *)sender setUserInteractionEnabled:NO];
    NSMutableString *phoneNumberString = [NSMutableString stringWithString:self.phoneNumberTextField.text];
    [phoneNumberString replaceOccurrencesOfString:@" " withString:@"" options:0 range:NSMakeRange(0, phoneNumberString.length)];
    [FXAppDelegate addHUDForView:self.view animate:YES];
    [FXRequestDataFormat changePasswordWithToken:[FXAppDelegate shareFXAppDelegate].token
                                          UserID:[FXAppDelegate shareFXAppDelegate].userID
                                    ValidateCode:self.identifyingCodeTextField.text
                                OriginalPassword:self.originPasswordTextField.text
                                        Password:self.passwordTextField.text
                                 PasswordConfirm:self.confirmPasswordTextField.text
                                        Finished:^(BOOL success, NSData *response) {
                                            [FXAppDelegate hideHUDForView:self.view animate:YES];
                                            NSLog(@"res = %@",response);
                                            [(UIButton *)sender setUserInteractionEnabled:YES];
                                            if (success) {
                                                //请求成功
                                                ChangePasswordResponse *resp = [ChangePasswordResponse parseFromData:response];
                                                if (resp.isSucceed) {
                                                    //修改成功
                                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                                                                    message:@"修改成功"
                                                                                                   delegate:self
                                                                                          cancelButtonTitle:@"确定"
                                                                                          otherButtonTitles:nil];
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        [alert show];
                                                    });
                                                }else{
                                                    //修改失败
                                                    [FXAppDelegate errorAlert:[self showErrorInfoWithResetPasswordErrorType:resp.errorCode]];
                                                }
                                            }else{
                                                //请求失败
                                                NSLog(@"request failed");
                                            }
                                        }];
}

//数字键盘上额外的完成键
- (void)keyboardDoneButtonClicked:(UIButton *)sender{
    
}

//键盘消失
- (void)keyboardDismissNotification:(NSNotification *)notification{
    [self doneButtonMoveToFooter];
}

#pragma mark done button 的位置
- (void)doneButtonMoveToKeyboard{
    [self.identifyingCodeTextField.inputAccessoryView addSubview:self.doneButton];
    self.doneButton.frame = (CGRect){kBlank_Size ,-1 ,self.view.frame.size.width - 2 * kBlank_Size ,kCell_Height};
}

- (void)doneButtonMoveToFooter{
    [self.footerView addSubview:self.doneButton];
    _doneButton.center = CGPointMake(_footerView.frame.size.width / 2, _footerView.frame.size.height - _doneButton.frame.size.height / 2 - 30);
    _doneButton.layer.cornerRadius = 4.;
}

#pragma mark - UIAlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark timer触发

//输入动作触发timer . 验证输入结果是否合法 ,并提示
- (void)timerFired:(NSTimer *)timer{
    NSString *originPasswordText = self.originPasswordTextField.text;
    NSString *passwordText = [self.passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *confirmPasswordText = [self.confirmPasswordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *phoneNumberText = [[self.phoneNumberTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *identifyingCodeText = [self.identifyingCodeTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (originPasswordText == nil || originPasswordText.length < 3) {
        self.originPasswordIsOK = NO;
        self.originPasswordTipLabel.text = @"!";
    }else{
        self.originPasswordIsOK = YES;
        self.originPasswordTipLabel.text = @"";
    }
    
    if (passwordText == nil || [passwordText isEqualToString:@""]) {
        self.passwordTipLabel.text = @"未输入新密码";
        self.passwordIsOK = NO;
    }else{
        if (confirmPasswordText == nil || ![passwordText isEqualToString:confirmPasswordText]) {
            self.passwordTipLabel.text = @"输入不一致";
            self.passwordIsOK = NO;
        }else{
            self.passwordTipLabel.text = @"";
            self.passwordIsOK = YES;
        }
    }
    
    if (phoneNumberText.length < 1) {
        self.alertLabel.text = @"请输入手机号";
        self.phoneNumberIsOK = NO;
    }else{
        if ([self isvalidatePhone:phoneNumberText]) { //电话号码格式正确
            self.alertLabel.text = @"";
            self.phoneNumberIsOK = YES;
            [self changeRewriteButtonStatus:YES];
            
        }else{
            self.alertLabel.text = @"格式错误!";
            self.phoneNumberIsOK = NO;
            [self changeRewriteButtonStatus:NO];
        }
    }
    
    if ([identifyingCodeText rangeOfString:@"^[0-9]{6}$" options:NSRegularExpressionSearch].length > 0) {
        self.alertIdentiyingLabel.text = @"";
        self.identiCodeIsOK = YES;
    }else{
        self.alertIdentiyingLabel.text = @"请输入验证码";
        self.identiCodeIsOK = NO;
    }
    
    [self changeDoneButtonStatus];
    
}

//计时timer触发
- (void)timingTimerFired:(NSTimer *)timer{
    if (self.identtifyingCodeTimer.isValid) {
        NSTimeInterval validateTime = [self.identtifyingCodeTimer.fireDate timeIntervalSinceNow]; //有效期
        self.coundDownLabel.text = [NSString stringWithFormat:@"%d秒内有效",(int)validateTime];
    }else{
        self.coundDownLabel.text = [NSString stringWithFormat:@""];
    }
    
    if (self.reSendTimer.isValid) {
        NSTimeInterval resendTime = [self.reSendTimer.fireDate timeIntervalSinceNow];  //重发时间
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *title = [NSString stringWithFormat:@"重发(%d)",(int)resendTime];
            [self.reSendButton setTitle:title forState:UIControlStateDisabled];
        });
    }else{
        [self.reSendButton setTitle:@"重新发送" forState:UIControlStateDisabled];
    }
}

//重发timer触发
- (void)reSendTimerFired:(NSTimer *)timer{
    //resend按钮解锁
    [self changeReSendButtonStatus:YES];
}

//验证码倒计时
- (void)identifyingCodeTimerFired:(NSTimer *)timer{
    
}

#pragma mark action

//改变resend按钮的状态
- (void)changeReSendButtonStatus:(BOOL)enabled{
    if (enabled) {
        self.reSendButton.enabled = YES;
        self.reSendButton.layer.borderColor = kColor(51, 51, 51, 1).CGColor;
        [self.reSendButton setTitleColor:kColor(51, 51, 51, 1) forState:UIControlStateNormal];
    }else{
        self.reSendButton.enabled = NO;
        self.reSendButton.layer.borderColor = kColor(193, 193, 193, 1).CGColor;
        [self.reSendButton setTitleColor:kColor(193, 193, 193, 1) forState:UIControlStateNormal];
    }
}

//改变重填按钮的状态
- (void)changeRewriteButtonStatus:(BOOL)enabled{
    if (enabled) {
        self.rewriteButton.enabled = YES;
        self.rewriteButton.layer.borderColor = kColor(51, 51, 51, 1).CGColor;
        [self.rewriteButton setTitleColor:kColor(51, 51, 51, 1) forState:UIControlStateNormal];
    }else{
        self.rewriteButton.enabled = NO;
        self.rewriteButton.layer.borderColor = kColor(193, 193, 193, 1).CGColor;
        [self.rewriteButton setTitleColor:kColor(193, 193, 193, 1) forState:UIControlStateNormal];
    }
}

//改变完成按钮的状态
- (void)changeDoneButtonStatus{
    if (self.passwordIsOK && self.originPasswordIsOK && self.identiCodeIsOK && self.phoneNumberIsOK) {
        self.doneButton.enabled = YES;
        self.doneButton.backgroundColor = kColor(209, 27, 33, 1);
    }else{
        self.doneButton.enabled = NO;
        self.doneButton.backgroundColor = kColor(201, 201, 201, 1);
    }
}

#pragma mark Notifications
- (BOOL)isvalidatePhone:(NSString *)phone{
    NSString *phoneRegex = @"^[1][34578][0-9]{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",phoneRegex];
    return [phoneTest evaluateWithObject:phone];
}

@end
