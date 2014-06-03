//
//  FXBlockedContactCell.h
//  FuXin
//
//  Created by lihongliang on 14-6-3.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactModel.h"
@protocol FXBlockedContactCellDelegate;
/*
 屏蔽管理的cell
 */
@interface FXBlockedContactCell : UITableViewCell
@property (nonatomic, strong) id<FXBlockedContactCellDelegate> delegate;

@property (nonatomic, strong) UIImageView *photoView; // 头像

@property (nonatomic, strong) UILabel *nameLabel;  //名字

@property (nonatomic, strong) UIButton *recoverButton; //恢复按钮

@property (nonatomic, strong) ContactModel *contactModel; //联系人模型
@end

@protocol FXBlockedContactCellDelegate <NSObject>
@required
- (void)blockedContactCell:(FXBlockedContactCell *)cell recoverContact:(ContactModel *)contact;
@end
