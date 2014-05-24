//
//  FXRegisterController.m
//  FuXin
//
//  Created by 徐宝桥 on 14-5-19.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXRegisterController.h"
#import "FXReviewController.h"

@interface FXRegisterController ()

@end

@implementation FXRegisterController

@synthesize phoneView = _phoneView;

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
    self.title = @"注册";
    self.view.backgroundColor = kColor(250, 250, 250, 1);
    [self initUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)initUI {
    _phoneView = [[FXInputView alloc] initWithFrame:CGRectMake(0, 40, 320, 56)];
    _phoneView.backgroundColor = [UIColor clearColor];
    _phoneView.showBottomBorder = YES;
    _phoneView.showTopBorder = YES;
    _phoneView.contentField.placeholder = @"请输入手机号码";
    _phoneView.contentField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_phoneView];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    nextButton.layer.cornerRadius = 4;
    nextButton.frame = CGRectMake(30, 133, 260, 43);
    nextButton.backgroundColor = kColor(209, 27, 33, 1);
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
}

#pragma mark - Action

- (IBAction)nextStep:(id)sender {
    FXReviewController *reviewC = [[FXReviewController alloc] init];
    reviewC.phoneNumber = _phoneView.contentField.text;
    [self.navigationController pushViewController:reviewC animated:YES];
}

@end
