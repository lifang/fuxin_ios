//
//  FXAddressListController.h
//  FuXin
//
//  Created by 徐宝桥 on 14-5-19.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXSearchViewController.h"
#import "FXTableHeaderView.h"

typedef enum {
    AddressListAll = 0,      //全部
    AddressListRecent,       //最近
    AddressListTrade,        //交易
    AddressListSubscribe,    //订阅
}AddressListTypes;    //通讯录类型

@interface FXAddressListController : FXSearchViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *dataTableView;

@property (nonatomic, strong) NSMutableArray *dataItems;

//记录选中的headerview
@property (nonatomic, strong) FXTableHeaderView *selectedHeaderView;

@end
