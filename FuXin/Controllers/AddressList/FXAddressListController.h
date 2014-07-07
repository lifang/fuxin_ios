//
//  FXAddressListController.h
//  FuXin
//
//  Created by 徐宝桥 on 14-5-19.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXSearchViewController.h"
#import "FXTableHeaderView.h"
#import "FXSelectIndexView.h"
#import "EGORefreshTableHeaderView.h"

typedef enum {
    AddressListRecent = 0,   //最近
    AddressListTrade,        //交易
    AddressListSubscribe,    //订阅
}AddressListTypes;    //通讯录类型

@interface FXAddressListController : FXSearchViewController<EGORefreshTableHeaderDelegate>

@property (nonatomic, strong) UITableView *dataTableView;

//获取的联系人列表
@property (nonatomic, strong) NSMutableArray *contactLists;

//筛选数组
@property (nonatomic, strong) NSMutableArray *recentLists;
@property (nonatomic, strong) NSMutableArray *tradeLists;
@property (nonatomic, strong) NSMutableArray *subscribeLists;

@property (nonatomic, assign) AddressListTypes listTypes;

//记录选中的headerview的index
@property (nonatomic, assign) NSInteger selectedHeaderViewIndex;
//右侧浮动框
@property (nonatomic, strong) FXSelectIndexView *indexView;

@property (nonatomic, strong) UISegmentedControl *segmentControl;

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, assign) BOOL reloading;
@property (nonatomic, retain) EGORefreshTableHeaderView *refreshHeaderView;

- (void)updateContactList:(NSArray *)list;

@end
