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
#define kMessageBoxWigthMax  220

@interface FXTextFormat : NSObject

+ (UIView *)getContentViewWithMessage:(NSString *)message;

@end
