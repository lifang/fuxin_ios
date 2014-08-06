//
//  FXUserInfoController.h
//  FuXin
//
//  Created by 徐宝桥 on 14-7-17.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXAdjustViewController.h"
#import "FXUserModel.h"

@interface FXUserInfoController : FXAdjustViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *userTableView;

@property (nonatomic, strong) FXUserModel *userInfo;

@end
