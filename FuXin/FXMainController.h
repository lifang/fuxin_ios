//
//  FXMainController.h
//  FuXin
//
//  Created by 徐宝桥 on 14-5-19.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXChatListController.h"
#import "FXAddressListController.h"
#import "FXSettingController.h"

//更新对话界面通知
static NSString *ChatNeedRefreshListNotification = @"ChatNeedRefreshListNotification";
//聊天界面添加消息
static NSString *ChatUpdateMessageNotification = @"ChatUpdateMessageNotification";
//更新联系人界面通知
static NSString *AddressNeedRefreshListNotification = @"AddressNeedRefreshListNotification";
//更新个人信息
static NSString *UpdateUserInfoNotification = @"UpdateUserInfoNotification";
//退到后台时接收消息
static NSString *PushMessageNotification = @"PushMessageNotification";
//刷新联系人
static NSString *UpdateContactNotification = @"UpdateContactNotification";
//刷新完联系人获取请求结果
static NSString *RequestFinishNotification = @"RequestFinishNotification";

@interface FXMainController : UITabBarController

@property (nonatomic, strong) UINavigationController *chatNav;
@property (nonatomic, strong) UINavigationController *addrNav;
@property (nonatomic, strong) UINavigationController *settNav;
@property (nonatomic, strong) NSTimer *timer;

- (void)cancelSource;

@end
