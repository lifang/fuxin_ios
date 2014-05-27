//
//  FXCompareCN.h
//  FuXin
//
//  Created by 徐宝桥 on 14-5-22.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//


//中文通讯录分组

#import <Foundation/Foundation.h>

#define kName  @"name"
#define kIndex @"index"

@interface FXCompareCN : NSObject

//返回数组为tableview右侧索引框
+ (NSMutableArray *)tableViewIndexArray:(NSArray *)nameArray;
//返回tableview每个section的数据源
+ (NSMutableArray *)dataForSectionWithArray:(NSArray *)nameArray;

@end
