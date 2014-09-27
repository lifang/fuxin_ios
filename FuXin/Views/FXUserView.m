//
//  FXUserView.m
//  FuXin
//
//  Created by 徐宝桥 on 14-5-16.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXUserView.h"

//用户头像与上下边界距离
#define kUserViewOffset  15

@implementation FXUserView

@synthesize userPhotoView = _userPhotoView;
@synthesize viewBound = _viewBound;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.viewBound = CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.backgroundColor = kColor(209, 27, 33, 1);
        //添加阴影
        [self addShadowView];
    }
    return self;
}

- (void)setViewBound:(CGRect)viewBound {
    _viewBound = viewBound;
    
    //设置用户头像view属性
    [self setUserPhotoView];
}

- (void)setUserPhotoView {
    CGFloat center_x = _viewBound.size.width / 2;
    CGFloat center_y = _viewBound.size.height / 2;
    CGFloat side = 0.f;
    if (center_y - kUserViewOffset > 0) {
        side = (center_y - kUserViewOffset ) * 2;
    }
    
    CGRect userViewRect = CGRectMake(center_x - side / 2, center_y - side / 2, side, side);
    _userPhotoView = [[UIImageView alloc] initWithFrame:userViewRect];
    _userPhotoView.layer.cornerRadius = side / 2;
    _userPhotoView.layer.borderWidth = 2;
    _userPhotoView.layer.borderColor = [[UIColor whiteColor] CGColor];
    _userPhotoView.layer.masksToBounds = YES;
    _userPhotoView.image = [UIImage imageNamed:@"placeholder.png"];
    [self addSubview:_userPhotoView];
}

- (void)addShadowView {
    FXShadowView *shadowView = [[FXShadowView alloc] initWithFrame:CGRectMake(0, 0, _viewBound.size.width, 5)];
    [self addSubview:shadowView];
}

@end
