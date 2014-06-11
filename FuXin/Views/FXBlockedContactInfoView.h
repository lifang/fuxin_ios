//
//  FXBlockedContactInfoView.h
//  FuXin
//
//  Created by lihongliang on 14-6-4.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FXBlockedContactInfoViewDelegate;
/*
  被屏蔽联系人的信息view
*/
@interface FXBlockedContactInfoView : UIView
@property (strong, nonatomic) UIView *contentBgView;       //信息栏背景
@property (strong, nonatomic) UIImageView *photoImageView; //照片
@property (strong, nonatomic) UILabel *nameLabel;          //昵称
@property (strong, nonatomic) UILabel *remarkLabel;         //备注
@property (strong, nonatomic) UIImageView *genderImageView;  //性别图片
@property (strong, nonatomic) UIView *buttonBgView;          //订购 / 交易等button的背景
@property (strong, nonatomic) UIButton *tradeButton;          //交易
@property (strong, nonatomic) UIButton *subscriptionButton;   //订阅

@property (strong, nonatomic) id<FXBlockedContactInfoViewDelegate> delegate;
@property (strong, nonatomic) ContactModel *contact;  //联系人
@end

@protocol FXBlockedContactInfoViewDelegate <NSObject>

@required
- (void)blockedContactInfoViewRecover:(FXBlockedContactInfoView *)infoView;

@end
