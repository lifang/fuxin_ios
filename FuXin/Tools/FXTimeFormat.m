//
//  FXTimeFormat.m
//  FuXin
//
//  Created by 徐宝桥 on 14-5-28.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXTimeFormat.h"

@implementation FXTimeFormat

+ (NSString *)setTimeFormatWithString:(NSString *)timeString {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *sendDate = [format dateFromString:timeString];
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger flag = NSMinuteCalendarUnit | NSHourCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit| NSMonthCalendarUnit | NSYearCalendarUnit | NSWeekCalendarUnit;
    NSDateComponents *sendC = [calendar components:flag fromDate:sendDate];
    NSDateComponents *nowC = [calendar components:flag fromDate:now];
//    NSDateComponents *diffC = [calendar components:flag fromDate:sendDate toDate:now options:0];
    NSString *result = nil;
    NSLog(@"week = %d,%d",nowC.week,sendC.week);
    
    if (abs(nowC.day - sendC.day) == 0) {
        //同日
        if (sendC.hour < 6) {
            result = @"凌晨";
        }
        else if (sendC.hour < 12) {
            result = @"上午";
        }
        else if (sendC.hour < 18) {
            result = @"下午";
        }
        else {
            result = @"晚上";
        }
        NSString *hourTime = [NSString stringWithFormat:@"%d",sendC.hour];
        if ([hourTime length] < 2) {
            hourTime = [NSString stringWithFormat:@"0%d",sendC.hour];
        }
        NSString *minTime = [NSString stringWithFormat:@"%d",sendC.minute];
        if ([minTime length] < 2) {
            minTime = [NSString stringWithFormat:@"0%d",sendC.minute];
        }
        result = [NSString stringWithFormat:@"%@%@:%@",result,hourTime,minTime];
    }
    else if (abs(nowC.day - sendC.day) == 1) {
        //最近一天
        result = [NSString stringWithFormat:@"昨天"];
    }
    else if (abs(nowC.day - sendC.day) < 7) {
        //最近七天
        if (abs(nowC.week - sendC.week) == 0) {
            result = [[self class] getWeekdayWithNumber:sendC.weekday];
        }
        else {
            result = [NSString stringWithFormat:@"%d-%d-%d",sendC.year,sendC.month,sendC.day];
        }
    }
    else {
        result = [NSString stringWithFormat:@"%d-%d-%d",sendC.year,sendC.month,sendC.day];
    }
    return result;
}

+ (NSString *)getWeekdayWithNumber:(int)index {
    NSString *weekday = nil;
    switch (index) {
        case 1:
            weekday = @"星期天";
            break;
        case 2:
            weekday = @"星期一";
            break;
        case 3:
            weekday = @"星期二";
            break;
        case 4:
            weekday = @"星期三";
            break;
        case 5:
            weekday = @"星期四";
            break;
        case 6:
            weekday = @"星期五";
            break;
        case 7:
            weekday = @"星期六";
            break;
        default:
            break;
    }
    return weekday;
}

+ (NSString *)nowDateString {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *now = [NSDate date];
    NSString *nowString = [format stringFromDate:now];
    NSLog(@"now = %@",nowString);
    return nowString;
}

+ (NSDate *)dateWithString:(NSString *)string {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [format dateFromString:string];
}

+ (BOOL)needShowTime:(NSString *)firstTimeString withTime:(NSString *)secondTimeString {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *first = [format dateFromString:firstTimeString];
    NSDate *second = [format dateFromString:secondTimeString];
    double diff = [first timeIntervalSinceDate:second];
    if (fabs(diff) > kTimeInterval) {
        return YES;
    }
    return NO;
}

@end
