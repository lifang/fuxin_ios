//
//  FXContactController.h
//  FuXin
//
//  Created by 徐宝桥 on 14-6-16.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXAdjustViewController.h"
#import "ContactModel.h"

@interface FXContactController : FXAdjustViewController

@property (nonatomic, strong) UITableView *detailTable;

@property (nonatomic, strong) ContactModel *contact;

@property (nonatomic, strong) NSString *ID;

@end
