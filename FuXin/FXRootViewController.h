//
//  FXRootViewController.h
//  FuXin
//
//  Created by 徐宝桥 on 14-5-17.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

//根控制器，用来切换loginView和mainView

#import "FXAdjustViewController.h"
#import "FXAppDelegate.h"

@interface FXRootViewController : FXAdjustViewController

- (void)showLoginViewController;
- (void)showMainViewController;

- (void)removeMainController;
- (void)releaseResource;

@end
