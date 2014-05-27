//
//  FXMyInfoViewController.m
//  FuXin
//
//  Created by SumFlower on 14-5-26.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXMyInfoViewController.h"

@interface FXMyInfoViewController ()

@end

@implementation FXMyInfoViewController

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
    self.title = @"我的信息";
    UIButton *leftbt = [UIButton buttonWithType:UIButtonTypeCustom];
    leftbt.frame = CGRectMake(0, 0, 32, 32);
    [leftbt setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftbt addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithCustomView:leftbt];
    self.navigationItem.leftBarButtonItem = left;
    
    CALayer *layer = [self.userImage layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:20.0];
    [layer setBorderWidth:1.0];
    [layer setBorderColor:[[UIColor blackColor] CGColor]];
    self.userImage.image = [UIImage imageNamed:@"user"];
    // Do any additional setup after loading the view from its nib.
}
-(void)backView
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
