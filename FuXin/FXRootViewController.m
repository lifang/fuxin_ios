//
//  FXRootViewController.m
//  FuXin
//
//  Created by 徐宝桥 on 14-5-17.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXRootViewController.h"

@interface FXRootViewController ()

@property (nonatomic, strong) FXMainController *mainController;

@end

@implementation FXRootViewController

@synthesize mainController = _mainController;

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
    _mainController = [[FXMainController alloc] init];
    if (_mainController.parentViewController == nil) {
        _mainController.view.frame = self.view.bounds;
        [self addChildViewController:_mainController];
        [self.view addSubview:_mainController.view];
    }
    loginNav.view.hidden = YES;
    _mainController.view.hidden = NO;
    [self.view bringSubviewToFront:_mainController.view];
}

- (void)removeMainController {
    [_mainController removeFromParentViewController];
    [_mainController.view removeFromSuperview];
    _mainController = nil;
}

@end
