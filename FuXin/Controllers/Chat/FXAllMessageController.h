//
//  FXAllMessageController.h
//  FuXin
//
//  Created by 徐宝桥 on 14-9-22.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXAdjustViewController.h"
#import "FXRequestDataFormat.h"

@interface FXAllMessageController : FXAdjustViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) ContactModel *contact;

@property (nonatomic, strong) UITableView *historyTableView;

@end
