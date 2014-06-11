//
//  FXLoginController.h
//  FuXin
//
//  Created by 徐宝桥 on 14-5-14.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXAdjustViewController.h"
#import "FXUserView.h"

@interface FXLoginController : FXAdjustViewController

//上部红色view
@property (nonatomic, strong) FXUserView *userView;

//用户名框
@property (nonatomic, strong) UITextField *usernameField;
//密码框
@property (nonatomic, strong) UITextField *passwordField;

//从本地读取此用户是否曾登录过
- (void)getUserInfoWithLogin:(BOOL)needLogin;

@end
