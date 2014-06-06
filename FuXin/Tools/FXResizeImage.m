//
//  FXResizeImage.m
//  FuXin
//
//  Created by 徐宝桥 on 14-6-6.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXResizeImage.h"

@implementation FXResizeImage

+ (UIImage *)scaleImage:(UIImage *)image {
    CGSize size = CGSizeMake(kResizeSide, kResizeSide);
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaleImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaleImage;
}

@end
