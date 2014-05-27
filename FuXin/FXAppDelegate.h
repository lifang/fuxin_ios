//
//  FXAppDelegate.h
//  FuXin
//
//  Created by 徐宝桥 on 14-5-14.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXRootViewController.h"
#import "FXLoginController.h"
#import "FXMainController.h"

@interface FXAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) FXRootViewController *rootController;

//登录返回的userID
@property (nonatomic, assign) int32_t userID;
//登录返回的令牌
@property (nonatomic, strong) NSString *token;

+ (FXAppDelegate *)shareFXAppDelegate;
- (FXRootViewController *)shareRootViewContorller;
+ (UINavigationController *)shareLoginViewController;
+ (FXMainController *)shareMainViewController;

+ (void)setNavigationBarTinColor:(UINavigationController *)nav;

@end