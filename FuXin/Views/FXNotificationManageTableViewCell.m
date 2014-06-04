//
//  FXNotificationManageTableViewCell.m
//  FuXin
//
//  Created by lihongliang on 14-6-4.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXNotificationManageTableViewCell.h"

@implementation FXNotificationManageTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView{
    _unreadLabel = [[UILabel alloc] init];
    _unreadLabel.backgroundColor = kColor(255, 0, 9, 1);
    _unreadLabel.textColor = [UIColor whiteColor];
    _unreadLabel.text = @"NEW";
    _unreadLabel.font = [UIFont systemFontOfSize:10.];
    _unreadLabel.frame = CGRectMake(2, 2, 29, 13);
    _unreadLabel.textAlignment = NSTextAlignmentCenter;
    _unreadLabel.layer.cornerRadius = _unreadLabel.frame.size.height / 2;
    _unreadLabel.clipsToBounds = YES;
    [self.contentView addSubview:_unreadLabel];
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.backgroundColor = [UIColor clearColor];
    _contentLabel.textColor = kColor(51, 51, 51, 1);
    _contentLabel.text = @"通知标题通知标题通知标题通知标题通知标题通知标题通知标题通知标题通知标题通知标题通知标题通知标题";
    _contentLabel.font = [UIFont systemFontOfSize:12.];
    _contentLabel.frame = CGRectMake(5, 13, 260, 22);
    _contentLabel.numberOfLines = 1;
    _contentLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_contentLabel];
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma property
- (void)setNotificationModel:(FXNotificationModel *)notificationModel{
    _notificationModel = notificationModel;
    _contentLabel.text = notificationModel.notiTitle;
    if (notificationModel.notiIsReaded) {
        _contentLabel.textColor = kColor(51, 51, 51, 1);
    }else{
        _contentLabel.textColor = kColor(191, 191, 191, 1);
    }
    _unreadLabel.hidden = notificationModel.notiIsReaded;
}
@end
