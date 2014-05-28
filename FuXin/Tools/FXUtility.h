//
//  FXUtility.h
//  FuXin
//
//  Created by lihongliang on 14-5-27.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FXUtility : NSObject
///计算一行文本的宽度
+ (CGSize)getTextSizeWithString:(NSString*)text withFont:(UIFont*)font;

///限定宽度 ,计算文本的尺寸
+ (CGSize)getTextSizeWithString:(NSString*)text withFont:(UIFont*)font withWidth:(CGFloat)width;
@end
