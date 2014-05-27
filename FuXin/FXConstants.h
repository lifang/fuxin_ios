//
//  FXConstants.h
//  FuXin
//
//  Created by 徐宝桥 on 14-5-14.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

//颜色转换浮点型表示
#define kColor(r,g,b,a) [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:a]

//屏幕高度
#define kScreenHeight  [UIScreen mainScreen].bounds.size.height

//手机系统版本
#define kDeviceVersion [[[UIDevice currentDevice] systemVersion] floatValue]
