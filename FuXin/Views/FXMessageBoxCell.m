//
//  FXMessageBoxCell.m
//  FuXin
//
//  Created by 徐宝桥 on 14-5-21.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXMessageBoxCell.h"
#import "FXChatViewController.h"

#define kMessageBoxHeightMin  36
#define kMessageBoxWithMin    40

#define kLargeOffset        55
#define kSmallOffset        40
#define kTimeLabelHeight    40

@implementation FXMessageBoxCell

@synthesize delegate = _delegate;
@synthesize cellStyle = _cellStyle;
@synthesize userPhotoView = _userPhotoView;
@synthesize backgroundView = _backgroundView;
@synthesize messageView = _messageView;
@synthesize timeLabel = _timeLabel;
@synthesize showTime = _showTime;
@synthesize contents = _contents;
@synthesize timeBackView = _timeBackView;

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
    _userPhotoView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _userPhotoView.userInteractionEnabled = YES;
    _backgroundView = [[UIImageView alloc] initWithFrame:CGRectZero];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.textAlignment = NSTextAlignmentCenter;

    _timeBackView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _timeBackView.image = [UIImage imageNamed:@"gray.png"];
    [self.contentView addSubview:_userPhotoView];
    [self.contentView addSubview:_backgroundView];
    [self.contentView addSubview:_timeBackView];
    [self.contentView addSubview:_timeLabel];
    
    UIView *backView = [[UIView alloc] initWithFrame:self.frame];
    backView.backgroundColor = [UIColor clearColor];
    self.selectedBackgroundView = backView;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showContactDetail:)];
    [_userPhotoView addGestureRecognizer:tap];
}

- (void)setSubviewsFrame {
    CGSize size = _messageView.frame.size;
    CGFloat adjustHeight = 0;
    if (size.height < kMessageBoxHeightMin) {
        adjustHeight = kMessageBoxHeightMin - size.height;
        size.height = kMessageBoxHeightMin;
    }
    size.width = size.width < kMessageBoxWithMin ? kMessageBoxWithMin : size.width;
    CGFloat timeOffset = 0;
    if (_showTime) {
        timeOffset = kTimeLabelHeight;
        _timeLabel.hidden = NO;
        _timeBackView.hidden = NO;
        _timeLabel.frame = CGRectMake(110, 2, 100, kTimeLabelHeight - 22);
        _timeLabel.textColor = [UIColor whiteColor];
        _timeBackView.frame = _timeLabel.frame;
        _timeBackView.layer.cornerRadius = 9;
        _timeBackView.layer.masksToBounds = YES;
    }
    else {
        _timeBackView.hidden = YES;
        _timeLabel.hidden = YES;
    }
    switch (_cellStyle) {
        case MessageCellStyleReceive: {
            _userPhotoView.frame = CGRectMake(5, kTimeLabelHeight - 5, 34, 34);
            _userPhotoView.layer.cornerRadius = _userPhotoView.bounds.size.width / 2;
            _userPhotoView.layer.masksToBounds = YES;
            
            _messageView.frame = CGRectMake(kLargeOffset, kTimeLabelHeight - 5, _messageView.bounds.size.width, _messageView.bounds.size.height);
            _backgroundView.frame = CGRectMake(kSmallOffset, kTimeLabelHeight - 7, size.width + 20, size.height + 4);
            _backgroundView.image = [[UIImage imageNamed:@"receive.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 30, 30, 30)];
            
        }
            break;
        case MessageCellStyleSender: {
            _userPhotoView.frame = CGRectMake(281, kTimeLabelHeight - 5, 34, 34);
            _userPhotoView.layer.cornerRadius = _userPhotoView.bounds.size.width / 2;
            _userPhotoView.layer.masksToBounds = YES;
            
            _messageView.frame = CGRectMake(320 - kSmallOffset - size.width - 14, kTimeLabelHeight - 5,_messageView.bounds.size.width, _messageView.bounds.size.height);

            _backgroundView.frame = CGRectMake(320 - kLargeOffset - size.width - 5, kTimeLabelHeight - 7, size.width + 20, size.height + 4);
            _backgroundView.image = [[UIImage imageNamed:@"sender.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 30, 30, 30)];
        }
            break;
        default:
            break;
    }
    if (adjustHeight > 0) {
        CGRect rect = _messageView.frame;
        rect.origin.y += adjustHeight / 2 + 2;
        _messageView.frame = rect;
    }
    [self.contentView addSubview:_messageView];
}

- (void)setContents:(NSString *)content {
    _contents = content;
    if (_messageView) {
        [_messageView removeFromSuperview];
    }
    _messageView = [FXTextFormat getContentViewWithMessage:_contents];
    [self setSubviewsFrame];
}

- (void)setImageData:(NSData *)data {
    if (_messageView) {
        [_messageView removeFromSuperview];
        _messageView = nil;
    }
    _messageView = [FXTextFormat getContentViewWithImageData:data];
    [self setSubviewsFrame];
}

- (void)setShowTime:(BOOL)showTime {
    _showTime = showTime;
    if (_showTime) {
        _timeLabel.hidden = NO;
    }
    else {
        _timeLabel.hidden = YES;
    }
}

#pragma mark - 手势

- (void)showContactDetail:(UITapGestureRecognizer *)tap {
    if (self.cellStyle == MessageCellStyleReceive) {
        if (_delegate && [_delegate respondsToSelector:@selector(touchContact:)]) {
            [_delegate touchContact:tap];
        }
    }
}

@end
