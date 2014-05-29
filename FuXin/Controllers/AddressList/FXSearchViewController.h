//
//  FXSearchViewController.h
//  FuXin
//
//  Created by 徐宝桥 on 14-5-24.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXAdjustViewController.h"
#import "FXRequestDataFormat.h"
#import "FXChatViewController.h"

@interface FXSearchViewController : FXAdjustViewController<UISearchBarDelegate,UISearchDisplayDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UISearchDisplayController *searchController;

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) NSArray *primaryArray;

@property (nonatomic, strong) NSMutableArray *resultArray;

- (void)hiddenExtraCellLineWithTableView:(UITableView *)table;

@end
