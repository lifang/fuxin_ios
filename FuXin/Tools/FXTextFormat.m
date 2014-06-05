//
//  FXTextFormat.m
//  FuXin
//
//  Created by 徐宝桥 on 14-6-4.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXTextFormat.h"

@implementation FXTextFormat

+ (void)getImageRange:(NSString *)message Array:(NSMutableArray *)array {
    NSRange range1 = [message rangeOfString:kBeginFlag];
    NSRange range2 = [message rangeOfString:kEndFlag];
    //判断当前字符串是否还有表情的标志。
    if (range1.length > 0 && range2.length > 0) {
        if (range1.location > 0) {
            [array addObject:[message substringToIndex:range1.location]];
            [array addObject:[message substringWithRange:NSMakeRange(range1.location, range2.location + 1 - range1.location)]];
            NSString *str = [message substringFromIndex:range2.location + 1];
            [self getImageRange:str Array:array];
        }
        else {
            NSString *nextStr = [message substringWithRange:NSMakeRange(range1.location, range2.location + 1 - range1.location)];
            //排除文字是“”的
            if (![nextStr isEqualToString:@""]) {
                [array addObject:nextStr];
                NSString *str = [message substringFromIndex:range2.location + 1];
                [self getImageRange:str Array:array];
            }
            else {
                return;
            }
        }
    }
    else if (message != nil) {
        [array addObject:message];
    }
}

+ (UIView *)getContentViewWithMessage:(NSString *)message {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [[self class] getImageRange:message Array:array];
    UIView *showView = [[UIView alloc] initWithFrame:CGRectZero];
    NSArray *dataArray = array;
    UIFont *font = [UIFont systemFontOfSize:14];
    CGFloat dx = 0;
    CGFloat dy = 0;
    CGFloat x = 0;
    CGFloat y = 0;
    if (dataArray) {
        for (int i = 0; i < [dataArray count]; i++) {
            NSString *string = [dataArray objectAtIndex:i];
            if ([string hasPrefix:kBeginFlag] && [string hasSuffix:kEndFlag]) {
                //图片
                if (dx >= kMessageBoxWigthMax - kFaceSide) {
                    //换行
                    dy += kFaceSide;
                    dx = 0;
                    x = kMessageBoxWigthMax;
                    y = dy;
                }
                NSString *imageName = [string substringWithRange:NSMakeRange(2, string.length - 3)];
                UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(dx, dy, kFaceSide, kFaceSide)];
                imgV.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",imageName]];
                [showView addSubview:imgV];
                dx += kFaceSide;
                if (x < kMessageBoxWigthMax) {
                    x = dx;
                }
            }
            else {
                //文字
                for (int j = 0; j < [string length]; j++) {
                    NSString *subString = [string substringWithRange:NSMakeRange(j, 1)];
                    if (dx >= kMessageBoxWigthMax - 10) {
                        dy += kFaceSide;
                        dx = 0;
                        x = kMessageBoxWigthMax;
                        y = dy;
                    }
                    CGSize size = [subString sizeWithFont:font constrainedToSize:CGSizeMake(kMessageBoxWigthMax, 20)];
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(dx, dy, size.width, size.height)];
                    label.font = font;
                    label.text = subString;
                    label.backgroundColor = [UIColor clearColor];
                    [showView addSubview:label];
                    dx += size.width;
                    if (x < kMessageBoxWigthMax) {
                        x = dx;
                    }
                }
                y += kFaceSide + 5;
            }
        }
    }
    showView.frame = CGRectMake(10, 1, x, y);
    return showView;
}

@end
