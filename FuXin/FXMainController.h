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

@interface FXMainController : UITabBarController

@property (nonatomic, strong) UINavigationController *chatNav;
@property (nonatomic, strong) UINavigationController *addrNav;
@property (nonatomic, strong) UINavigationController *settNav;

@end
