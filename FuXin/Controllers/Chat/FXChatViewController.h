//
//  FXChatViewController.h
//  FuXin
//
//  Created by 徐宝桥 on 14-5-20.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXAdjustViewController.h"

@interface FXChatViewController : FXAdjustViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *chatTableView;

@property (nonatomic, strong) NSMutableArray *dataItems;

@end
