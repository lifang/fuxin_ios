//
//  FXAlterView.h
//  FuXin
//
//  Created by SumFlower on 14-5-26.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FXAlterView : UIView
@property (strong, nonatomic)  UIImageView *userImage;//用户照片
@property (strong, nonatomic)  UILabel *userName;//用户姓名
@property (strong, nonatomic)  UILabel *userWebName;//用户网络名
@property (strong, nonatomic)  UIImageView *userSex;//用户性别
@property (strong, nonatomic)  UIButton *renZhenOneBt;//认证图标
@property (strong, nonatomic)  UIButton *renZhenTwoBt;//认证图标
@property (strong, nonatomic)  UIButton *confirmBt;//
-(void)initWithView;
@end
