//
//  FXTextFormat.h
//  FuXin
//
//  Created by 徐宝桥 on 14-6-4.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kBeginFlag   @"[#"
#define kEndFlag     @"]"  //表情标识

#define kFaceSide    24    //表情大小

//聊天内容宽度最大值
#define kMessageBoxWidthMax  220

//历史记录宽度最大值
#define kHistoryWidthMax    300

//图片最大宽度
#define kImageWidthMax     120

@interface FXTextFormat : NSObject

//文字
+ (UIView *)getContentViewWithMessage:(NSString *)message width:(CGFloat)maxWidth;

//图片
+ (UIView *)getContentViewWithImageData:(NSData *)data;

+ (NSDictionary *)getEmojiList;

@end
