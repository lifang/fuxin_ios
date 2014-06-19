//
//  FXTimeFormat.h
//  FuXin
//
//  Created by 徐宝桥 on 14-5-28.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>

//时间间隔 用于显示时间
#define kTimeInterval  300

@interface FXTimeFormat : NSObject

+ (NSString *)setTimeFormatWithString:(NSString *)timeString;

+ (NSString *)nowDateString;

+ (NSDate *)dateWithString:(NSString *)string;

+ (BOOL)needShowTime:(NSString *)firstTimeString withTime:(NSString *)secondTimeString;

@end
