//
//  FXSearchViewController.h
//  FuXin
//
//  Created by 徐宝桥 on 14-5-24.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXAdjustViewController.h"

@interface FXSearchViewController : FXAdjustViewController<UISearchBarDelegate,UISearchDisplayDelegate>

@property (nonatomic, strong) UISearchDisplayController *searchController;

@property (nonatomic, strong) UISearchBar *searchBar;

@end
