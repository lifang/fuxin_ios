//
//  FXForgotPasswordController.m
//  FuXin
//
//  Created by lihongliang on 14-5-24.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXForgotPasswordController.h"

#define kBlank_Size 15
#define kCell_Height 44

@interface FXForgotPasswordController ()
//控件区
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;   //密码
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;  //确认密码
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;   //提示信息
@property (weak, nonatomic) IBOutlet UILabel *coundDownLabel;   //验证码倒计时
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;  //电话号码
@property (weak, nonatomic) IBOutlet UITextField *identifyingCodeTextField;  //验证码
@property (weak, nonatomic) IBOutlet UILabel *alertLabel;   //电话号码错误警示
@property (weak, nonatomic) IBOutlet UILabel *alertIdentiyingLabel;   //验证码错误警示
@property (weak, nonatomic) IBOutlet UIButton *rewriteButton;   //重填电话号码
@property (weak, nonatomic) IBOutlet UIButton *reSendButton;    //重发验证码
@property (weak, nonatomic) IBOutlet UIButton *checkButton;    //选中同意
@property (weak, nonatomic) IBOutlet UIButton *serviceTextButton;   //服务协议
@property (weak, nonatomic) IBOutlet UILabel *agreeLabel;   //酱油
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

//数据区

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
    
    self.title = @"找回密码";
    self.view.backgroundColor = kColor(250, 250, 250, 1);
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self initViews];
}

//各种控件初始化
- (void)initViews{
    self.tableView.backgroundColor = [UIColor yellowColor];
    NSLog(@"%@",NSStringFromCGRect(self.tableView.frame));
    NSLog(@"%@",NSStringFromCGRect(self.view.frame));
    
    for (UIView *subview in self.view.subviews){
        if (subview == self.tableView || subview == self.doneButton) {
            continue;
        }
        [subview removeFromSuperview];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    self.doneButton.frame = (CGRect){kBlank_Size ,self.view.frame.size.height - 40 - kCell_Height ,self.view.frame.size.width - 2 * kBlank_Size ,kCell_Height};
    
    //table边缘有30像素的白边
    self.tableView.frame = (CGRect){kBlank_Size ,kBlank_Size ,self.view.frame.size.width - 2 * kBlank_Size ,self.doneButton.frame.origin.y - 2 * kBlank_Size};
}

- (void)viewDidAppear:(BOOL)animated{
    
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
    return kCell_Height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    switch (indexPath.row) {
        case 0:  //密码
            if ([self cell:cell isNotSuperOfView:self.passwordTextField]) {
                CGSize cellSize = cell.frame.size;
                self.passwordTextField.frame = (CGRect){10 ,0 ,2 * cellSize.width / 3 ,cellSize.height};
                [cell.contentView addSubview:self.passwordTextField];
            }
            break;
        case 1:   //确认密码
            if ([self cell:cell isNotSuperOfView:self.confirmPasswordTextField]) {
                CGSize cellSize = cell.frame.size;
                self.confirmPasswordTextField.frame = (CGRect){10 ,0 ,2 * cellSize.width / 3 ,cellSize.height};
                [cell.contentView addSubview:self.confirmPasswordTextField];
            }
            break;
        case 2:    //电话号码
            if ([self cell:cell isNotSuperOfView:self.phoneNumberTextField]) {
                CGSize cellSize = cell.frame.size;
                self.phoneNumberTextField.frame = (CGRect){10 ,0 ,cellSize.width / 2 ,cellSize.height};
                [cell.contentView addSubview:self.phoneNumberTextField];
            }
            break;
        case 3:    //验证码
            if ([self cell:cell isNotSuperOfView:self.identifyingCodeTextField]) {
                CGSize cellSize = cell.frame.size;
                self.identifyingCodeTextField.frame = (CGRect){10 ,0 ,cellSize.width / 2 ,cellSize.height};
                [cell.contentView addSubview:self.identifyingCodeTextField];
            }
            break;
        case 4:    //提示信息
            if ([self cell:cell isNotSuperOfView:self.tipLabel]) {
                CGSize cellSize = cell.frame.size;
                self.tipLabel.frame = (CGRect){10 ,0 ,2 * cellSize.width / 3 ,cellSize.height};
                [cell.contentView addSubview:self.tipLabel];
            }
            if ([self cell:cell isNotSuperOfView:self.coundDownLabel]) {
                CGSize cellSize = cell.frame.size;
                self.coundDownLabel.frame = (CGRect){10 ,0 ,2 * cellSize.width / 3 ,cellSize.height};
                [cell.contentView addSubview:self.coundDownLabel];
            }
            break;
        case 5:    //服务协议
            if ([self cell:cell isNotSuperOfView:self.checkButton]) {
                CGSize cellSize = cell.frame.size;
                self.checkButton.frame = (CGRect){10 ,0 ,2 * cellSize.width / 3 ,cellSize.height};
                [self.checkButton addTarget:self action:@selector(checkButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:self.checkButton];
            }
            if ([self cell:cell isNotSuperOfView:self.agreeLabel]) {
                CGSize cellSize = cell.frame.size;
                self.agreeLabel.frame = (CGRect){10 ,0 ,2 * cellSize.width / 3 ,cellSize.height};
                [cell.contentView addSubview:self.agreeLabel];
            }
            if ([self cell:cell isNotSuperOfView:self.serviceTextButton]) {
                CGSize cellSize = cell.frame.size;
                self.serviceTextButton.frame = (CGRect){10 ,0 ,2 * cellSize.width / 3 ,cellSize.height};
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

#pragma mark 控件响应
- (void)checkButtonClicked:(id)sender{
    
}

@end
