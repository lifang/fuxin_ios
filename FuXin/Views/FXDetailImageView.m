//
//  FXDetailImageView.m
//  FuXin
//
//  Created by 徐宝桥 on 14-6-10.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXDetailImageView.h"

@implementation FXDetailImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.backgroundColor = [UIColor blackColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeSelf)];
    [self addGestureRecognizer:tap];
    _bigImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _progressView = [[EVCircularProgressView alloc] init];
    CGRect rect = _progressView.frame;
    rect.origin.x = (self.bounds.size.width - _progressView.bounds.size.width) / 2;
    rect.origin.y = (self.bounds.size.height - _progressView.bounds.size.height) / 2;
    _progressView.frame = rect;
    [self addSubview:_progressView];
    [self addSubview:_bigImageView];
}

- (void)setBigImageWithData:(NSData *)data {
    UIImage *image = [UIImage imageWithData:data];
    CGSize size = image.size;
    if (size.width > 320) {
        size.height = size.height * 320 / size.width;
        size.width = 320;
    }
    if (size.height > kScreenHeight) {
        size.width = size.width * kScreenHeight / size.height;
        size.height = kScreenHeight;
    }
    CGFloat originX = (self.bounds.size.width - size.width) / 2;
    CGFloat originY = (self.bounds.size.height - size.height) / 2;
    CGRect rect = CGRectMake(originX, originY, size.width, size.height);
    _bigImageView.frame = rect;
    _bigImageView.image = image;
}

- (void)removeSelf {
    [self removeFromSuperview];
}

@end
