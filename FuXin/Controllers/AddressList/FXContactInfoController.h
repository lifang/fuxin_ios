//
//  FXContactInfoController.h
//  FuXin
//
//  Created by 徐宝桥 on 14-7-16.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXAdjustViewController.h"

@interface FXContactInfoController : FXAdjustViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *detailTable;

@property (nonatomic, strong) ContactModel *contact;

@property (nonatomic, strong) NSString *ID;

@end
