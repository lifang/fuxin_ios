//
//  FXAdjustViewController.m
//  FuXin
//
//  Created by 徐宝桥 on 14-5-20.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXAdjustViewController.h"

@interface FXAdjustViewController ()

@end

@implementation FXAdjustViewController

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
    float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVersion >= 7.0) {
        //支持7.0以上版本的方法
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 导航栏按钮

- (void)setLeftNavBarItem {
//    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back.png"]
//                                                             style:UIBarButtonItemStyleBordered
//                                                            target:self
//                                                            action:@selector(back:)];
//    self.navigationItem.leftBarButtonItem = left;
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 32, 32);
    [leftButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = left;
}

- (void)setRightNavBarItem {
//    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"info.png"]
//                                                              style:UIBarButtonItemStyleBordered
//                                                             target:self
//                                                             action:@selector(rightBarTouched:)];
//    self.navigationItem.rightBarButtonItem = right;
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 32, 32);
    [rightButton setBackgroundImage:[UIImage imageNamed:@"info.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightBarTouched:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = right;
    
}

#pragma mark - 子类重写

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)rightBarTouched:(id)sender {
    
}

@end
