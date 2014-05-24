//
//  FXRootViewController.m
//  FuXin
//
//  Created by 徐宝桥 on 14-5-17.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXRootViewController.h"
#import "FXAppDelegate.h"

@interface FXRootViewController ()

@end

@implementation FXRootViewController

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
    [self showLoginViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//登录界面
- (void)showLoginViewController {
    UINavigationController *loginNav = [FXAppDelegate shareLoginViewController];
    if (loginNav.parentViewController == nil) {
        loginNav.view.frame = self.view.bounds;
        [self addChildViewController:loginNav];
        [self.view addSubview:loginNav.view];
    }
    loginNav.view.hidden = NO;
    [self.view bringSubviewToFront:loginNav.view];
}

//主界面
- (void)showMainViewController {
    UINavigationController *loginNav = [FXAppDelegate shareLoginViewController];
    FXMainController *mainNav = [FXAppDelegate shareMainViewController];
    if (mainNav.parentViewController == nil) {
        mainNav.view.frame = self.view.bounds;
        [self addChildViewController:mainNav];
        [self.view addSubview:mainNav.view];
    }
    loginNav.view.hidden = YES;
    mainNav.view.hidden = NO;
    [self.view bringSubviewToFront:mainNav.view];
}

@end
