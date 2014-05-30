//
//  FXChatCell.h
//  FuXin
//
//  Created by 徐宝桥 on 14-5-20.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FXChatCell : UITableViewCell

@property (nonatomic, strong) UIImageView *photoView;

@property (nonatomic, strong) UILabel *numberLabel;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, strong) UIImageView *backView;

- (void)setNumber:(NSString *)number;

@end
