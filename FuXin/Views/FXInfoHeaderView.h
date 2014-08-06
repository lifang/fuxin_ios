//
//  FXInfoHeaderView.h
//  FuXin
//
//  Created by 徐宝桥 on 14-7-16.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FXInfoHeaderView : UIView

@property (nonatomic, strong) UIImageView *backView;

@property (nonatomic, strong) UIImageView *photoView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, strong) UIButton *modifyBtn;

//联系人
- (void)setContact:(ContactModel *)contact;

//个人信息
- (void)setUser:(FXUserModel *)user;

@end
