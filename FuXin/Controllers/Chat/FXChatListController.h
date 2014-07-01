//
//  FXChatListController.h
//  FuXin
//
//  Created by 徐宝桥 on 14-5-19.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXSearchViewController.h"
#import "FXAdjustViewController.h"

@interface FXChatListController : FXAdjustViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *chatListTable;

@property (nonatomic, strong) NSMutableArray *chatList;

//消息总数，用于显示在tabbar上
@property (nonatomic, assign) int messageCount;


- (void)updateChatList:(NSArray *)list;

@end
