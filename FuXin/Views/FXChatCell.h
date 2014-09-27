//
//  FXChatCell.h
//  FuXin
//
//  Created by 徐宝桥 on 14-5-20.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXListCell.h"

@interface FXChatCell : FXListCell

@property (nonatomic, strong) UILabel *numberLabel;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, strong) UIImageView *backView;

@property (nonatomic, strong) UIImageView *blockView;

- (void)setNumber:(NSString *)number;

@end
