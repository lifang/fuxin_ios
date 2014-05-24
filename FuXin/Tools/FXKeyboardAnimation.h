//
//  FXKeyboardAnimation.h
//  FuXin
//
//  Created by 徐宝桥 on 14-5-21.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FXKeyboardAnimation : NSObject

+ (void)moveUpView:(UIView *)view withOffset:(CGFloat)height;
+ (void)resetView:(UIView *)view withOffset:(CGFloat)height;

@end
