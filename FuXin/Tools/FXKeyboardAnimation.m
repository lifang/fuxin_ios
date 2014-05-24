
//
//  FXKeyboardAnimation.m
//  FuXin
//
//  Created by 徐宝桥 on 14-5-21.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXKeyboardAnimation.h"

@implementation FXKeyboardAnimation

+ (void)moveUpView:(UIView *)view withOffset:(CGFloat)height {
    NSTimeInterval duration = 0.3f;
    CGRect rect = view.frame;
    rect.origin.y -= height;
    [UIView beginAnimations:@"adjustKeyboard" context:nil];
    [UIView setAnimationDuration:duration];
    view.frame = rect;
    [UIView commitAnimations];
}

+ (void)resetView:(UIView *)view withOffset:(CGFloat)height{
    NSTimeInterval duration = 0.3f;
    CGRect rect = view.frame;
    rect.origin.y += height;
    [UIView beginAnimations:@"adjustKeyboard" context:nil];
    [UIView setAnimationDuration:duration];
    view.frame = rect;
    [UIView commitAnimations];
}

@end
