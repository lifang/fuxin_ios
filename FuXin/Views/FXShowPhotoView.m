//
//  FXShowPhotoView.m
//  FuXin
//
//  Created by 徐宝桥 on 14-5-25.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXShowPhotoView.h"

#define kSpace       30
#define kWidth       50
#define kHeight      80

@implementation FXShowPhotoView

@synthesize pictureDelegate = _pictureDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = kColor(250, 250, 250, 1);
        [self initUI];
        [self addButtonWithTag:ButtonTagePicture];
        [self addButtonWithTag:ButtonTagPhoto];
    }
    return self;
}

- (void)initUI {
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
    topLine.backgroundColor = kColor(206, 206, 206, 1);
    [self addSubview:topLine];
}

- (void)addButtonWithTag:(ButtonTags)tag {
    CGFloat originX = ((tag % 4) - 1) * (kSpace + kWidth) + 15;
    CGFloat originY = (tag / 4) * (kSpace + kHeight) + 15;
    NSString *imageNameNormal = @"";
    NSString *imageNameSelected = @"";
    NSString *titleName = @"";
    switch (tag) {
        case ButtonTagePicture:{
            imageNameNormal = @"picture.png";
            imageNameSelected = @"pictureselected.png";
            titleName = @"图片";
        }
            break;
        case ButtonTagPhoto: {
            imageNameNormal = @"camera.png";
            imageNameSelected = @"cameraselected.png";
            titleName = @"拍照";
        }
            break;
        default:
            break;
    }
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(originX, originY, kWidth, kHeight);
    btn.tag = tag;
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:imageNameNormal] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:imageNameSelected] forState:UIControlStateHighlighted];
    [btn setTitle:titleName forState:UIControlStateNormal];
    btn.titleEdgeInsets = UIEdgeInsetsMake(55, -50, 3, 1);
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 30, 0);
    [btn addTarget:self action:@selector(touched:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
}

- (IBAction)touched:(id)sender {
    if (_pictureDelegate && [_pictureDelegate respondsToSelector:@selector(pictureButtonFunctionWithTag:)]) {
        [_pictureDelegate pictureButtonFunctionWithTag:[(UIButton *)sender tag]];
    }
}

@end
