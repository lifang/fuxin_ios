//
//  FXShadowView.m
//  FuXin
//
//  Created by 徐宝桥 on 14-5-16.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXShadowView.h"

@implementation FXShadowView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef startColor = CGColorCreate(colorSpace, CGColorGetComponents(kColor(177, 23, 28, 1).CGColor));
    CGColorRef endColor = CGColorCreate(colorSpace, CGColorGetComponents(kColor(209, 27, 33, 1).CGColor));
    
    CFArrayRef colorArray = CFArrayCreate(kCFAllocatorDefault, (const void *[]){startColor,endColor}, 2, nil);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, colorArray, (CGFloat[]){0.0, 1.0});
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), CGPointMake(0, self.frame.size.height), 0);
    
    CGGradientRelease(gradient);
    CFRelease(colorArray);
    CGColorSpaceRelease(colorSpace);
    CGColorRelease(startColor);
    CGColorRelease(endColor);
}

@end
