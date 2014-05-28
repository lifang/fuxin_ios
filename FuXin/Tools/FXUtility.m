//
//  FXUtility.m
//  FuXin
//
//  Created by lihongliang on 14-5-27.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXUtility.h"

@implementation FXUtility

+ (CGSize)getTextSizeWithString:(NSString*)text withFont:(UIFont*)font withWidth:(CGFloat)width{
    if (text && font) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            CGSize size = [text boundingRectWithSize:(CGSize){width,MAXFLOAT} options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: font} context:nil].size;
            return size;
        }else{
            if([text isEqualToString:@""]){
                //如果为空字符串,则本方法给出符合字体的基本高度,以与ios7的方法保持一致
                text = @"1";
            }
            CGSize size = [[text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] sizeWithFont:font constrainedToSize:(CGSize){width,MAXFLOAT} lineBreakMode:NSLineBreakByWordWrapping];
            return size;
        }
    } else {
        return CGSizeZero;
    }
}

+ (CGSize)getTextSizeWithString:(NSString*)text withFont:(UIFont*)font{
    if (text && font) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            return [text sizeWithAttributes:@{NSFontAttributeName: font}];
        }else{
            CGSize size = [text sizeWithFont:font];
            return size;
        }
    } else {
        return CGSizeZero;
    }
}

@end
