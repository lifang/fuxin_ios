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

typedef enum {
    AddressListAll = 0,      //全部
    AddressListRecent,       //最近
    AddressListTrade,        //交易
    AddressListSubscribe,    //订阅
}AddressListTypes;    //通讯录类型

@interface FXAddressListController : FXSearchViewController

@property (nonatomic, strong) UITableView *dataTableView;

//获取的联系人 名字数组
@property (nonatomic, strong) NSMutableArray *nameLists;
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

- (void)updateContactList:(NSArray *)list;

@end
