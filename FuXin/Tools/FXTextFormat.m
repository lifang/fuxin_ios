//
//  FXTextFormat.m
//  FuXin
//
//  Created by 徐宝桥 on 14-6-4.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXTextFormat.h"

static NSDictionary *_emojiList;

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
                if (dx >= kMessageBoxWidthMax - kFaceSide) {
                    //换行
                    dy += kFaceSide;
                    dx = 0;
                    x = kMessageBoxWidthMax;
                    y = dy;
                }
                NSString *imageName = [string substringWithRange:NSMakeRange(2, string.length - 3)];
                UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(dx, dy, kFaceSide, kFaceSide)];
                NSString *keyName = [[self class] imageNameForValue:imageName];
                imgV.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",keyName]];
                [showView addSubview:imgV];
                dx += kFaceSide;
                if (x < kMessageBoxWidthMax) {
                    x = dx;
                }
            }
            else {
                //文字
                for (int j = 0; j < [string length]; j++) {
                    NSString *subString = [string substringWithRange:NSMakeRange(j, 1)];
                    //若转化为c字符串为null说明可能是emoji表情，与后一字符合并
                    if (![subString cStringUsingEncoding:NSUTF8StringEncoding] && j + 1 < [string length]) {
                        subString = [string substringWithRange:NSMakeRange(j, 2)];
                        j++;
                    }
                    if (dx >= kMessageBoxWidthMax - 10) {
                        dy += kFaceSide;
                        dx = 0;
                        x = kMessageBoxWidthMax;
                        y = dy;
                    }
                    CGSize size = [subString sizeWithFont:font constrainedToSize:CGSizeMake(CGFLOAT_MAX, 20)];
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(dx, dy + 3, size.width, size.height)];
                    label.font = font;
                    label.text = subString;
                    label.backgroundColor = [UIColor clearColor];
                    [showView addSubview:label];
                    dx += size.width;
                    if (x < kMessageBoxWidthMax) {
                        x = dx;
                    }
                }
            }
        }
    }
    y += kFaceSide + 5;
    showView.frame = CGRectMake(10, 1, x, y);
    return showView;
}

+ (UIView *)getContentViewWithImageData:(NSData *)data {
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectZero];
    UIImage *content = [UIImage imageWithData:data];
    //下载的数据不是图片返回nil
    if (!content) {
        return nil;
    }
    UIImageView *imgV = [[UIImageView alloc] initWithImage:content];
    CGRect rect = imgV.frame;
    rect.size = [[self class] resizeWithSize:imgV.frame.size];
    rect.origin = CGPointZero;
    imgV.frame = rect;
    [contentView addSubview:imgV];
    contentView.frame = rect;
    return contentView;
}

//3:2调整图片
+ (CGSize)resizeWithSize:(CGSize)size {
    CGSize resize = size;
    CGFloat rate = size.width / size.height;
    if (rate > 1.5) {
        //宽高比大于3:2
        if (size.width > kImageWidthMax) {
            //宽度大于最大值 等比缩小
            resize.width = kImageWidthMax;
            resize.height = size.height * kImageWidthMax / size.width;
        }
    }
    else {
        //宽高比小于3:2
        //两部分目前实现一样，分开实现是防止以后会限定图片最高值，只需改此处即可
        if (size.width > kImageWidthMax) {
            resize.width = kImageWidthMax;
            resize.height = size.height * kImageWidthMax / size.width;
        }
    }
    return resize;
}


#pragma mark - 表情
//表情编码

+ (NSDictionary *)getEmojiList {
    if (!_emojiList) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"FXEmojiList" ofType:@"plist"];
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
        _emojiList = [dict objectForKey:@"list"];
    }
    return _emojiList;
}

+ (NSString *)imageNameForValue:(NSString *)value {
    NSDictionary *dict = [[self class] getEmojiList];
    for (NSString *key in dict) {
        if ([[dict objectForKey:key] isEqualToString:value]) {
            return key;
        }
    }
    return nil;
}

@end
