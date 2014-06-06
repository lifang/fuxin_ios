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

@interface FXMainController : UITabBarController

@property (nonatomic, strong) UINavigationController *chatNav;
@property (nonatomic, strong) UINavigationController *addrNav;
@property (nonatomic, strong) UINavigationController *settNav;

- (void)cancelSource;

@end
