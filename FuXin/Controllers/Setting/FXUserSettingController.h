//
//  FXUserSettingController.h
//  FuXin
//
//  Created by 徐宝桥 on 14-6-3.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXAdjustViewController.h"
#import "FXUserModel.h"

@interface FXUserSettingController : FXAdjustViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *userTableView;

@property (nonatomic, strong) FXUserModel *userInfo;

@end
