//
//  FXNotificationManageViewController.h
//  FuXin
//
//  Created by lihongliang on 14-6-4.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXAdjustViewController.h"
/*
    系统通知管理
 */
@interface FXNotificationManageViewController : FXAdjustViewController<UITableViewDataSource ,UITableViewDelegate>
@property (strong ,nonatomic) NSMutableArray *dataArray;
@end
