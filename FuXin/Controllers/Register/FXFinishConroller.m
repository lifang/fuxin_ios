//
//  FXFinishConroller.m
//  FuXin
//
//  Created by 徐宝桥 on 14-5-19.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXFinishConroller.h"

@interface FXFinishConroller ()

@end

@implementation FXFinishConroller

@synthesize nameField = _nameField;
@synthesize passwordField = _passwordField;
@synthesize repeatField = _repeatField;

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

- (void)initUI {
    CGFloat originY = 40;
    //昵称
    _nameField = [[FXInputView alloc] initWithFrame:CGRectMake(0, originY, 320, 56)];
    _nameField.backgroundColor = [UIColor clearColor];
    _nameField.showTopBorder = YES;
    _nameField.showBottomBorder = NO;
    _nameField.contentField.placeholder = @"请输入昵称";
    [self.view addSubview:_nameField];
    
    originY += _nameField.frame.size.height;
    
    //密码
    _passwordField = [[FXInputView alloc] initWithFrame:CGRectMake(0, originY, 320, 56)];
    _passwordField.backgroundColor = [UIColor clearColor];
    _passwordField.showTopBorder = YES;
    _passwordField.showBottomBorder = NO;
    _passwordField.contentField.placeholder = @"请输入新密码";
    [self.view addSubview:_passwordField];
    
    originY += _passwordField.frame.size.height;
    
    _repeatField = [[FXInputView alloc] initWithFrame:CGRectMake(0, originY, 320, 56)];
    _repeatField.backgroundColor = [UIColor clearColor];
    _repeatField.showTopBorder = YES;
    _repeatField.showBottomBorder = YES;
    _repeatField.contentField.placeholder = @"请确认新密码";
    [self.view addSubview:_repeatField];
    
    UIButton *finishButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    finishButton.layer.cornerRadius = 4;
    finishButton.frame = CGRectMake(30, 240, 260, 43);
    finishButton.backgroundColor = kColor(209, 27, 33, 1);
    [finishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [finishButton setTitle:@"完成" forState:UIControlStateNormal];
    [finishButton addTarget:self action:@selector(finish:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:finishButton];
}

#pragma mark - Action

- (IBAction)finish:(id)sender {
    
}

@end
