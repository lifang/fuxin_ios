//
//  FXMainController.m
//  FuXin
//
//  Created by 徐宝桥 on 14-5-19.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXMainController.h"
#import "FXAppDelegate.h"

@interface FXMainController ()

@end

@implementation FXMainController

@synthesize chatNav = _chatNav;
@synthesize addrNav = _addrNav;
@synthesize settNav = _settNav;

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
    
    self.tabBar.selectedImageTintColor = [UIColor redColor];
    
    [self initControllers];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Controllers

- (void)initControllers {
    FXChatListController *chatC = [[FXChatListController alloc] init];
    chatC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"对话"
                                                    image:[UIImage imageNamed:@"chat.png"]
                                                      tag:0];
    _chatNav = [[UINavigationController alloc] initWithRootViewController:chatC];
    [FXAppDelegate setNavigationBarTinColor:_chatNav];
    
    FXAddressListController *addressC = [[FXAddressListController alloc] init];
    addressC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"通讯录"
                                                        image:[UIImage imageNamed:@"addr.png"]
                                                        tag:1];
    _addrNav = [[UINavigationController alloc] initWithRootViewController:addressC];
    [FXAppDelegate setNavigationBarTinColor:_addrNav];
    
    FXSettingController *settingC = [[FXSettingController alloc] init];
    settingC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"设置"
                                                        image:[UIImage imageNamed:@"setting.png"]
                                                        tag:2];
    _settNav = [[UINavigationController alloc] initWithRootViewController:settingC];
    [FXAppDelegate setNavigationBarTinColor:_settNav];
    
    self.viewControllers = [NSArray arrayWithObjects:_chatNav, _addrNav, _settNav, nil];
}

@end
