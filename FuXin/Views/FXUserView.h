//
//  FXUserView.h
//  FuXin
//
//  Created by 徐宝桥 on 14-5-16.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXShadowView.h"

@interface FXUserView : UIView

//用户头像
@property (nonatomic, strong) UIImageView *userPhotoView;

//此view的bound属性
@property (nonatomic, assign) CGRect viewBound;

@end
