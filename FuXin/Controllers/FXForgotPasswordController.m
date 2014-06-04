//
//  FXForgotPasswordController.m
//  FuXin
//
//  Created by lihongliang on 14-5-24.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXForgotPasswordController.h"
#import "FXRequestDataFormat.h"
#import "FXServiceAgreementViewController.h"

#define kBlank_Size 15   //边缘空白
#define kCell_Height 44   
#define kReSendTime 20  //重发验证码间隔
#define kIdentifyingCodeTime 20   //验证码有效期

@interface FXForgotPasswordController ()
//控件区
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;   //密码
@property (strong, nonatomic) IBOutlet UILabel *passwordTipLabel;  //密码输入提示
@property (strong, nonatomic) IBOutlet UITextField *confirmPasswordTextField;  //确认密码
@property (strong, nonatomic) IBOutlet UILabel *tipLabel;   //提示信息
@property (strong, nonatomic) IBOutlet UILabel *coundDownLabel;   //验证码倒计时
@property (strong, nonatomic) IBOutlet UITextField *phoneNumberTextField;  //电话号码
@property (strong, nonatomic) IBOutlet UITextField *identifyingCodeTextField;  //验证码
@property (strong, nonatomic) IBOutlet UILabel *alertLabel;   //电话号码错误警示
@property (strong, nonatomic) IBOutlet UILabel *alertIdentiyingLabel;   //验证码错误警示
@property (strong, nonatomic) IBOutlet UIButton *rewriteButton;   //重填电话号码
@property (strong, nonatomic) IBOutlet UIButton *reSendButton;    //重发验证码
@property (strong, nonatomic) IBOutlet UIButton *checkButton;    //选中同意
@property (strong, nonatomic) IBOutlet UIButton *serviceTextButton;   //服务协议
@property (strong, nonatomic) IBOutlet UILabel *agreeLabel;   //酱油
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) UIView *lineView; //一条线

- (IBAction)spaceAreaClicked:(id)sender;

//数据区
@property (strong, nonatomic) NSString *phoneNumberString; //真实电话号码
@property (assign, nonatomic) BOOL serviceTextAgreed; //已同意"服务条款"
@property (assign, nonatomic) BOOL passwordIsOK; //密码无问题
@property (assign, nonatomic) BOOL identiCodeIsOK;  //验证码OK

//其他
@property (strong ,nonatomic) NSTimer *inputAlertTimer; //输入1秒后提示timer
@property (strong ,nonatomic) NSTimer *reSendTimer;   //重发验证码timer
@property (strong ,nonatomic) NSTimer *identtifyingCodeTimer;  //验证码有效期timer
@property (strong ,nonatomic) NSTimer *timingTimer;  //计时timer
@end

@implementation FXForgotPasswordController

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
    
    [self setLeftNavBarItemWithImageName:@"back.png"];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.showsVerticalScrollIndicator = NO;
    [self initViews];
    
    self.timingTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timingTimerFired:) userInfo:nil repeats:YES];
    self.serviceTextAgreed = YES;
    self.passwordIsOK = NO;
    self.identiCodeIsOK = NO;
    
}

//各种控件初始化
- (void)initViews{
    for (UIView *subview in self.view.subviews){
        self.title = @"找回密码";
        self.view.backgroundColor = kColor(250, 250, 250, 1);
        
        if (subview == self.tableView || subview == self.doneButton) {
            continue;
        }
        [subview removeFromSuperview];
    }
    self.tableView.backgroundColor = [UIColor clearColor];
    
//    self.tableView.scrollEnabled = NO;
    
    self.passwordTipLabel.textColor = kColor(255, 0, 9, 1);
    self.alertLabel.textColor = kColor(255, 0, 9, 1);
    self.alertIdentiyingLabel.textColor = kColor(255, 0, 9, 1);
    
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.keyboardType = UIKeyboardTypeASCIICapable;
    self.passwordTextField.returnKeyType = UIReturnKeyNext;
    self.passwordTextField.textColor = kColor(51, 51, 51, 1);
    self.passwordTextField.delegate = self;
    
    self.confirmPasswordTextField.secureTextEntry = YES;
    self.confirmPasswordTextField.keyboardType = UIKeyboardTypeASCIICapable;
    self.confirmPasswordTextField.returnKeyType = UIReturnKeyNext;
    self.confirmPasswordTextField.textColor = kColor(51, 51, 51, 1);
    self.confirmPasswordTextField.delegate = self;
    
    self.phoneNumberTextField.textColor = kColor(51, 51, 51, 1);
    self.phoneNumberTextField.delegate = self;
    self.phoneNumberTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    self.phoneNumberTextField.returnKeyType = UIReturnKeyNext;
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = kColor(191, 191, 191, 1);
    
    [self changeRewriteButtonStatus:NO];
    [self.rewriteButton setTitle:@"确认" forState:UIControlStateNormal];
    self.rewriteButton.layer.cornerRadius = 6.;
    self.rewriteButton.layer.borderWidth = .7;
    [self.rewriteButton addTarget:self action:@selector(rewriteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.identifyingCodeTextField.textColor = kColor(51, 51, 51, 1);
    self.identifyingCodeTextField.delegate = self;
    self.identifyingCodeTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    self.identifyingCodeTextField.returnKeyType = UIReturnKeyDone;
//    self.identifyingCodeTextField.returnKeyType = UIReturnKeyDone;
    
    [self.checkButton addTarget:self action:@selector(checkButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.agreeLabel.textColor = kColor(51, 51, 51, 1);
    
    NSMutableAttributedString *buttonString = [[NSMutableAttributedString alloc] initWithString:@"服务协议"];
    [buttonString addAttribute:NSForegroundColorAttributeName value:kColor(255, 0, 9, 1) range:NSMakeRange(0, buttonString.length)];
    [buttonString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(0, buttonString.length)];
    [self.serviceTextButton setAttributedTitle:buttonString forState:UIControlStateNormal];
    [self.serviceTextButton addTarget:self action:@selector(serviceTextButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self changeReSendButtonStatus:NO];
    [self.reSendButton setTitle:@"重新发送" forState:UIControlStateNormal];
    self.reSendButton.layer.cornerRadius = 6.;
    self.reSendButton.layer.borderWidth = .7;
    [self.reSendButton addTarget:self action:@selector(reSendButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.doneButton.layer.cornerRadius = 4.;
    self.doneButton.backgroundColor = kColor(255, 0, 9, 1);
    [self.doneButton addTarget:self action:@selector(doneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self changeDoneButtonStatus];
}

- (void)viewWillAppear:(BOOL)animated{
    
    self.doneButton.frame = (CGRect){kBlank_Size ,self.view.frame.size.height - 40 - kCell_Height ,self.view.frame.size.width - 2 * kBlank_Size ,kCell_Height};
    
    //table边缘有30像素的白边
    self.tableView.frame = (CGRect){kBlank_Size ,0 ,self.view.frame.size.width - 2 * kBlank_Size ,self.doneButton.frame.origin.y - 2 * kBlank_Size};
}

- (void)viewDidAppear:(BOOL)animated{
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
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
    //同时调整table尺寸
    tableView.frame = (CGRect){kBlank_Size ,0 ,self.view.frame.size.width - 2 * kBlank_Size ,6 * kCell_Height - 1};
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 160, 0);
    return kCell_Height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    CGSize cellSize = cell.frame.size;
    switch (indexPath.row) {
        case 0:  //密码
            if ([self cell:cell isNotSuperOfView:self.passwordTextField]) {
                self.passwordTextField.frame = (CGRect){10 ,0 ,cellSize.width / 2 ,cellSize.height};
                [cell.contentView addSubview:self.passwordTextField];
            }
            break;
        case 1:   //确认密码
            if ([self cell:cell isNotSuperOfView:self.confirmPasswordTextField]) {
                self.confirmPasswordTextField.frame = (CGRect){10 ,0 ,cellSize.width / 2 ,cellSize.height};
                [cell.contentView addSubview:self.confirmPasswordTextField];
            }
            if ([self cell:cell isNotSuperOfView:self.passwordTipLabel]) { //密码输入提示
                self.passwordTipLabel.frame = (CGRect){cellSize.width - 10 - cellSize.width / 4 ,0 ,cellSize.width / 4 ,cellSize.height};
                [cell.contentView addSubview:self.passwordTipLabel];
            }
            break;
        case 2:    //电话号码
            if ([self cell:cell isNotSuperOfView:self.phoneNumberTextField]) {
                self.phoneNumberTextField.frame = (CGRect){10 ,0 ,cellSize.width / 3 ,cellSize.height};
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
            break;
        case 3:    //验证码
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
        case 4:    //提示信息
            if ([self cell:cell isNotSuperOfView:self.tipLabel]) {
                self.tipLabel.frame = (CGRect){10 ,0 ,2 * cellSize.width / 3 ,cellSize.height};
                [cell.contentView addSubview:self.tipLabel];
            }
            if ([self cell:cell isNotSuperOfView:self.coundDownLabel]) {   //验证码倒计时
                self.coundDownLabel.frame = (CGRect){(cellSize.width * 3 / 4) - 10 ,0 ,cellSize.width / 4 ,cellSize.height};
                [cell.contentView addSubview:self.coundDownLabel];
            }
            break;
        case 5:
            if ([self cell:cell isNotSuperOfView:self.checkButton]) {   //选中同意
                self.checkButton.frame = (CGRect){5 ,(cellSize.height - 19) / 2 ,19 ,19};
                [cell.contentView addSubview:self.checkButton];
            }
            if ([self cell:cell isNotSuperOfView:self.agreeLabel]) {
                self.agreeLabel.frame = (CGRect){CGRectGetMaxX(self.checkButton.frame) + 10 ,0 ,2 * cellSize.width / 3 ,cellSize.height};
                [cell.contentView addSubview:self.agreeLabel];
            }
            if ([self cell:cell isNotSuperOfView:self.serviceTextButton]) { //服务协议
                self.serviceTextButton.frame = (CGRect){CGRectGetMaxX(self.checkButton.frame) + 94 ,0 ,cellSize.width / 4 ,cellSize.height - 1};
                [cell.contentView addSubview:self.serviceTextButton];
            }
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
        }
        return NO;
    }
    
    if (textField == self.phoneNumberTextField) {  //电话号码特殊格式
        if ([string isEqualToString:@""]) {
            return YES;
        }
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
        if ([string isEqualToString:@""]) {
            return YES;
        }
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
    
    return YES;
}

#pragma mark 控件响应
- (IBAction)spaceAreaClicked:(id)sender {
    [self.passwordTextField resignFirstResponder];
    [self.confirmPasswordTextField resignFirstResponder];
    [self.phoneNumberTextField resignFirstResponder];
    [self.identifyingCodeTextField resignFirstResponder];
}

- (void)checkButtonClicked:(id)sender{ //复选框
    UIButton *button = (UIButton *)sender;
    if ((button.tag != 34)) {
        button.tag = 34;
        [button setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
        self.serviceTextAgreed = NO;
    }else{
        button.tag = 33;
        [button setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
        self.serviceTextAgreed = YES;
    }
    [self changeDoneButtonStatus];
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
}

//点击电话号码按钮
- (void)rewriteButtonClicked:(UIButton *)sender{
    UIView *superView = [sender superview];
    if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"确认"]) {
        //1,发送验证码
        [self changeReSendButtonStatus:NO];
        if (self.reSendTimer) {
            [self.reSendTimer invalidate];
        }
        self.reSendTimer = [NSTimer scheduledTimerWithTimeInterval:kReSendTime target:self selector:@selector(reSendTimerFired:) userInfo:nil repeats:NO];
        if (self.identtifyingCodeTimer) {
            [self.identtifyingCodeTimer invalidate];
        }
        self.identtifyingCodeTimer = [NSTimer scheduledTimerWithTimeInterval:kIdentifyingCodeTime target:self selector:@selector(identifyingCodeTimerFired:) userInfo:nil repeats:NO];
        
        //2
        [sender setTitle:@"重填" forState:UIControlStateNormal];
        self.tipLabel.text = @"验证码已发送至您的手机";
        superView.backgroundColor = kColor(241, 241, 241, 1);
        self.phoneNumberTextField.enabled = NO;
        self.phoneNumberTextField.textColor = kColor(135, 135, 135, 1);
        [self.identifyingCodeTextField becomeFirstResponder];
    }else if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"重填"]){
        self.phoneNumberTextField.text = @"";
        [self.reSendTimer invalidate];
        [self.identtifyingCodeTimer invalidate];
        
        [sender setTitle:@"确认" forState:UIControlStateNormal];
        superView.backgroundColor = [UIColor clearColor];
        self.phoneNumberTextField.enabled = YES;
        self.phoneNumberTextField.textColor = kColor(51, 51, 51, 1);
    }
}

//完成
- (void)doneButtonClicked:(UIButton *)sender{
    
}

//服务协议按钮
- (void)serviceTextButtonClicked:(UIButton *)sender{
    FXServiceAgreementViewController *agreement = [[FXServiceAgreementViewController alloc] init];
    [self.navigationController pushViewController:agreement animated:YES];
}

//数字键盘上额外的完成键
- (void)keyboardDoneButtonClicked:(UIButton *)sender{
    
}
#pragma mark timer触发

//文本输入动作 触发timer . 验证输入结果是否合法
- (void)timerFired:(NSTimer *)timer{
    UITextField *textField = (UITextField *)[timer.userInfo objectForKey:@"textField"];
    if (textField) {
        NSString *passwordText = [self.passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *confirmPasswordText = [self.confirmPasswordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *phoneNumberText = [[self.phoneNumberTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *identifyingCodeText = [self.identifyingCodeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if (passwordText == nil || [passwordText isEqualToString:@""]) {
            self.passwordTipLabel.text = @"未输入密码";
            self.passwordIsOK = NO;
        }else{
            if (confirmPasswordText == nil || ![passwordText isEqualToString:confirmPasswordText]) {
                self.passwordTipLabel.text = @"密码不一致";
                self.passwordIsOK = NO;
            }else{
                self.passwordTipLabel.text = @"";
                self.passwordIsOK = YES;
            }
        }
        
        if ([phoneNumberText rangeOfString:@"^[0-9]{11}$" options:NSRegularExpressionSearch].length > 0) { //电话号码格式正确
            self.alertLabel.text = @"";
            [self changeRewriteButtonStatus:YES];
            
        }else{
            self.alertLabel.text = @"格式错误!";
            [self changeRewriteButtonStatus:NO];
        }
        
        
        if ([identifyingCodeText isEqualToString:@"123456"]) {  //验证码正确
            self.alertIdentiyingLabel.text = @"验证码正确!";
            self.alertIdentiyingLabel.textColor = [UIColor greenColor];
            self.reSendButton.hidden = YES;
            self.rewriteButton.hidden = YES;
            self.coundDownLabel.text = @"";
            [self.reSendTimer invalidate];
            self.identiCodeIsOK = YES;
            [self.identifyingCodeTextField resignFirstResponder];
            self.identifyingCodeTextField.enabled = NO;
        }else{
            self.alertIdentiyingLabel.text = @"验证码错误!";
            self.alertIdentiyingLabel.textColor = kColor(255, 0, 9, 1);
        }
        [self changeDoneButtonStatus];
    }
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
    if (self.serviceTextAgreed && self.identiCodeIsOK && self.passwordIsOK) {
        self.doneButton.enabled = YES;
        self.doneButton.backgroundColor = kColor(209, 27, 33, 1);
    }else{
        self.doneButton.enabled = NO;
        self.doneButton.backgroundColor = kColor(201, 201, 201, 1);
    }
}

#pragma mark Notifications

#pragma mark KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        NSValue *oldOffset = [change objectForKey:@"old"];
        NSValue *newOffset = [change objectForKey:@"new"];
        CGPoint oldCoordinate;
        CGPoint newCoordinate;
        [oldOffset getValue:&oldCoordinate];
        [newOffset getValue:&newCoordinate];
        CGFloat distance = newCoordinate.y -  oldCoordinate.y;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.doneButton.center = CGPointMake(self.doneButton.center.x, self.doneButton.center.y - distance);
        });
    }
}

@end
