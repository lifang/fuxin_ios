//
//  FXArchiverHelper.h
//  FuXin
//
//  Created by 徐宝桥 on 14-6-6.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXUserModel.h"

#define kUserPath            @"userLoginInfo"
#define kHistoryLoginUsers   @"histiryLoginUsers"

@interface FXArchiverHelper : NSObject

//获取当前登录用户的信息（若此用户未登录 返回为nil）
+ (FXUserModel *)getUserInfoWithLoginName:(NSString *)loginName;
//保存当前用户信息
+ (void)saveUserInfo:(FXUserModel *)user;

+ (void)print;

@end
