//
//  FXChatListController.h
//  FuXin
//
//  Created by 徐宝桥 on 14-5-19.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXSearchViewController.h"

@interface FXChatListController : FXSearchViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *chatListTable;

@property (nonatomic, strong) NSMutableArray *chatList;


- (void)updateChatList:(NSArray *)list;

@end
