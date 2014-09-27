//
//  FXHistoryCell.m
//  FuXin
//
//  Created by 徐宝桥 on 14-9-22.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXHistoryCell.h"

@implementation FXHistoryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initUI];
    }
    return self;
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

- (void)initUI {
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 20)];
    _nameLabel.font = [UIFont systemFontOfSize:14];
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_nameLabel];
    [self.contentView addSubview:_timeLabel];
    UIView *backView = [[UIView alloc] initWithFrame:self.frame];
    backView.backgroundColor = [UIColor clearColor];
    self.selectedBackgroundView = backView;
}

- (void)setSubviewsFrame {
    _messageView.frame = CGRectMake(10, 20,_messageView.bounds.size.width, _messageView.bounds.size.height);
    [self.contentView addSubview:_messageView];
}

- (void)setName:(NSString *)name userID:(int32_t)userID {
    FXAppDelegate *delegate = [FXAppDelegate shareFXAppDelegate];
    if (delegate.userID == userID) {
        //发送
        _nameLabel.text = delegate.user.name;
        _nameLabel.textColor = kColor(23, 132, 217, 1);
    }
    else {
        //接收
        _nameLabel.text = name;
        _nameLabel.textColor = kColor(72, 181, 124, 1);
    }
    [_nameLabel sizeToFit];
    CGRect rect = _nameLabel.frame;
    if (rect.size.width > 120) {
        rect.size.width = 120;
    }
    rect.size.height = 20;
    _nameLabel.frame = rect;
}

- (void)setTime:(NSString *)time {
    _timeLabel.frame = CGRectMake(_nameLabel.frame.origin.x + _nameLabel.frame.size.width + 10, 0, 150, 20);
    _timeLabel.text = [FXTimeFormat setTimeFormatWithString:time];
}

- (void)setContents:(NSString *)content {
    _contents = content;
    if (_messageView) {
        [_messageView removeFromSuperview];
    }
    _messageView = [FXTextFormat getContentViewWithMessage:_contents width:kHistoryWidthMax];
    [self setSubviewsFrame];
}

- (void)setNullView {
    if (_messageView) {
        [_messageView removeFromSuperview];
        _messageView = nil;
    }
    _messageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 80)];
    [self setSubviewsFrame];
}

- (void)setImageData:(NSData *)data {
    if (_messageView) {
        [_messageView removeFromSuperview];
        _messageView = nil;
    }
    _imageData = data;
    _messageView = [FXTextFormat getContentViewWithImageData:data];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchPicture)];
//    [_messageView addGestureRecognizer:tap];
    [self setSubviewsFrame];
}

@end
