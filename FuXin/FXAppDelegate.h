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
//获取消息的时间戳
@property (nonatomic, strong) NSString *messageTimeStamp;
//获取联系人的时间戳
@property (nonatomic, strong) NSString *contactTimeStamp;
//是否在聊天界面，用于接收消息
@property (nonatomic, assign) BOOL isChatting;

//公用的titleLabel
@property (nonatomic, strong) UILabel *attributedTitleLabel;

+ (FXAppDelegate *)shareFXAppDelegate;
- (FXRootViewController *)shareRootViewContorller;
+ (UINavigationController *)shareLoginViewController;

+ (void)setNavigationBarTinColor:(UINavigationController *)nav;

+ (void)errorAlert:(NSString *)message;

///要显示"服务网v1.0"的页面可以调用.
+ (void)showFuWuTitle;
@end
