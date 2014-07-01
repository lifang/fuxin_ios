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
    
    _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _saveBtn.frame = CGRectMake(130, kScreenHeight - 60, 60, 30);
    _saveBtn.layer.cornerRadius = 4;
    _saveBtn.layer.masksToBounds = YES;
    _saveBtn.layer.borderWidth = 1;
    _saveBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [_saveBtn setBackgroundColor:[UIColor clearColor]];
    _saveBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_saveBtn setTitle:@"保存图片" forState:UIControlStateNormal];
    [_saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_saveBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [_saveBtn addTarget:self action:@selector(saveImage:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_saveBtn];
}

- (void)setBigImageWithData:(NSData *)data {
    _imageData = data;
    UIImage *image = [UIImage imageWithData:data];
    [self setBigImageWithImage:image];
}

- (void)setBigImageWithImage:(UIImage *)image {
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

- (void)saveImage:(UIButton *)sender {
    UIImage *image = [UIImage imageWithData:_imageData];
    if (image) {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"下载图片失败！"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    NSString *info = @"";
    if (error != NULL) {
        info = @"图片保存到相册失败！";
    }
    else {
        info = @"成功保存至相册！";
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:info
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

@end
