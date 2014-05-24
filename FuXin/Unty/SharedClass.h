//
//  SharedClass.h
//  FuXin
//
//  Created by lihongliang on 14-5-19.
//  Copyright (c) 2014年 comdosoft. All rights reserved.
//

/*
 单例数据
 */

#import <Foundation/Foundation.h>

@interface SharedClass : NSObject
+ (instancetype)sharedObject; //单例对象

@property (strong, nonatomic) NSString *userID;  //当前用户ID   切换帐号时修改
@end
