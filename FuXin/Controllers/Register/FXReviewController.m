//
//  FXReviewController.m
//  FuXin
//
//  Created by 徐宝桥 on 14-5-19.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXReviewController.h"
#import "FXFinishConroller.h"

@interface FXReviewController ()

@end

@implementation FXReviewController

@synthesize phoneView = _phoneView;
@synthesize codeView = _codeView;
@synthesize phoneNumber = _phoneNumber;

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
    self.view.backgroundColor = kColor(250, 250, 250, 1);
    
    [self initUI];
    
    [self initContents];
    self.title = @"注册";
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)initUI {
    CGFloat originY = 0;
    //顶部的提示框
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, originY, 300, 40)];
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.textColor = [UIColor grayColor];
    infoLabel.font = [UIFont systemFontOfSize:14];
    infoLabel.text = @"已向手机发送验证码，请输入验证码";
    [self.view addSubview:infoLabel];
    
    originY += infoLabel.frame.size.height;
    
    //手机号码
    _phoneView = [[FXInputView alloc] initWithFrame:CGRectMake(0, originY, 320, 56)];
    _phoneView.backgroundColor = kColor(241, 241, 241, 1);
    _phoneView.showTopBorder = YES;
    _phoneView.showBottomBorder = NO;
    _phoneView.contentField.userInteractionEnabled = NO;
    [self.view addSubview:_phoneView];
    
    originY += _phoneView.frame.size.height;
    
    //验证码
    _codeView = [[FXInputView alloc] initWithFrame:CGRectMake(0, originY, 320, 56)];
    _codeView.backgroundColor = [UIColor clearColor];
    _codeView.showTopBorder = YES;
    _codeView.showBottomBorder = YES;
    _codeView.contentField.placeholder = @"请输入验证码";
    [self.view addSubview:_codeView];
    
    UIButton *reviewButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    reviewButton.layer.cornerRadius = 4;
    reviewButton.frame = CGRectMake(30, 200, 260, 43);
    reviewButton.backgroundColor = kColor(209, 27, 33, 1);
    [reviewButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [reviewButton setTitle:@"确认" forState:UIControlStateNormal];
    [reviewButton addTarget:self action:@selector(check:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reviewButton];
}

//设置初值
- (void)initContents {
    _phoneView.contentField.text = _phoneNumber;
}

#pragma mark - Action

- (IBAction)check:(id)sender {
    FXFinishConroller *finishC = [[FXFinishConroller alloc] init];
    [self.navigationController pushViewController:finishC animated:YES];
}

@end
