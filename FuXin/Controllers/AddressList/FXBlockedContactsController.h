//
//  FXBlockedContactsController.h
//  FuXin
//
//  Created by lihongliang on 14-6-3.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXAdjustViewController.h"
#import "ContactModel.h"
#import "FXBlockedContactCell.h"

@interface FXBlockedContactsController : FXAdjustViewController<UITableViewDataSource ,UITableViewDelegate ,FXBlockedContactCellDelegate>
@property (strong, nonatomic) UITableView *tableView;   //table
@property (strong, nonatomic) NSMutableArray *dataArray;  //数据源
@end
