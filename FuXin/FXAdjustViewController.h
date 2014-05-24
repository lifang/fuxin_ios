//
//  FXAdjustViewController.h
//  FuXin
//
//  Created by 徐宝桥 on 14-5-20.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

//简单的适配view，大多数controller继承此类

#import <UIKit/UIKit.h>

@interface FXAdjustViewController : UIViewController

- (void)setLeftNavBarItem;
- (void)setRightNavBarItem;

//子类可能重写的方法
- (IBAction)back:(id)sender;
- (IBAction)rightBarTouched:(id)sender;

@end
