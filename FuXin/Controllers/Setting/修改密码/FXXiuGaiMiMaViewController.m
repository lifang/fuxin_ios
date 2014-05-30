//
//  FXXiuGaiMiMaViewController.m
//  FuXin
//
//  Created by SumFlower on 14-5-26.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//


#import "FXXiuGaiMiMaViewController.h"
@interface FXXiuGaiMiMaViewController ()
@property (nonatomic, assign) int count;
@property (nonatomic, assign) BOOL panduan;
@end

@implementation FXXiuGaiMiMaViewController

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
    self.title = @"修改密码";
    self.oldPassWord.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.oldPassWord.delegate = self;
    self.nowPassWord.delegate = self;
    self.confirmPassWord.delegate = self;
    self.yanZhenMa.delegate = self;
    self.phoneNumber.delegate = self;
    
    [self.confirmSender setTitle:@"确定" forState:UIControlStateNormal];
    self.confirmSender.layer.cornerRadius = 6.;
    self.confirmSender.layer.borderWidth = .7;
    [self.confirmSender.layer setMasksToBounds:YES];
    [self.confirmSender addTarget:self action:@selector(clickSenderBt) forControlEvents:UIControlEventTouchUpInside];
    
    [self.reSender setTitle:@"重新发送" forState:UIControlStateNormal];
    self.reSender.layer.cornerRadius = 6.;
    self.reSender.layer.borderWidth = .7;
    [self.reSender.layer setMasksToBounds:YES];
    [self.reSender addTarget:self action:@selector(reSenderAction) forControlEvents:UIControlEventTouchUpInside];
    

    

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)clickSenderBt
{

    if ([self.phoneNumber.text rangeOfString:@"^[0-9]{11}$" options:NSRegularExpressionSearch].length > 0) {//判断电话号码格式
        NSLog(@"电话号码格式正确");
        self.panduan = YES;
        //发送验证码
        
        //按钮设置
        self.confirmSender.userInteractionEnabled = NO;
        self.confirmSender.hidden = YES;
        
        //计时
        self.timingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countTime) userInfo:nil repeats:YES];
    }else{
        NSLog(@"电话号码格式错误");
        self.formalError.hidden = NO;
    }
}
-(void)countTime
{
    self.count++;
    NSLog(@"%i",self.count);
    self.titleTwo.hidden = NO;
    self.titleOne.hidden = NO;

    self.titleTwo.text = [NSString stringWithFormat:@"%i秒过期",self.count];
    
    self.reSender.userInteractionEnabled = NO;
    if (self.count == 5) {
        NSLog(@"验证码过期");
        self.reSender.userInteractionEnabled = YES;
        self.titleTwo.text = @"已过期";
        self.titleOne.hidden = YES;
        self.titleTwo.hidden = YES;
        [self.timingTimer invalidate];
        self.count = 0;
    }
}
-(void)reSenderAction
{
    if (self.panduan) {
    //发送验证码
        
    self.timingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countTime) userInfo:nil repeats:YES];
    }
    NSLog(@"请填写手机号");
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (IBAction)changeEdit:(id)sender {
    self.formalError.hidden = YES;
}
@end
