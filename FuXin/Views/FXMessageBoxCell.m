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

#define kLargeOffset        55
#define kSmallOffset        40
#define kTimeLabelHeight    40

@implementation FXMessageBoxCell

@synthesize cellStyle = _cellStyle;
@synthesize userPhotoView = _userPhotoView;
@synthesize backgroundView = _backgroundView;
@synthesize contentLabel = _contentLabel;
@synthesize timeLabel = _timeLabel;
@synthesize showTime = _showTime;

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
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _contentLabel.backgroundColor = [UIColor clearColor];
    _contentLabel.font = [UIFont systemFontOfSize:14];
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView addSubview:_userPhotoView];
    [self.contentView addSubview:_backgroundView];
    [self.contentView addSubview:_contentLabel];
    [self.contentView addSubview:_timeLabel];
    
    UIView *backView = [[UIView alloc] initWithFrame:self.frame];
    backView.backgroundColor = [UIColor clearColor];
    self.selectedBackgroundView = backView;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showContactDetail:)];
    [_userPhotoView addGestureRecognizer:tap];
}

- (void)setSubviewsFrame {
    CGSize size = [self getContextSizeWithString:_contentLabel.text];
    size.height = size.height > kMessageBoxHeightMin ? size.height : kMessageBoxHeightMin;
    CGFloat timeOffset = 0;
    if (_showTime) {
        timeOffset = kTimeLabelHeight;
        _timeLabel.frame = CGRectMake(2, 0, self.frame.size.width, kTimeLabelHeight - 4);
    }
    switch (_cellStyle) {
        case MessageCellStyleReceive: {
            _userPhotoView.frame = CGRectMake(5, kTimeLabelHeight, 34, 34);
            _userPhotoView.layer.cornerRadius = _userPhotoView.bounds.size.width / 2;
            _userPhotoView.layer.masksToBounds = YES;
            
            _contentLabel.frame = CGRectMake(kLargeOffset, kTimeLabelHeight - 1, size.width , size.height);
            _contentLabel.numberOfLines = 0;
            _backgroundView.frame = CGRectMake(kSmallOffset, kTimeLabelHeight - 2, size.width + 20, size.height + 1);
            _backgroundView.image = [[UIImage imageNamed:@"receive.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 30, 30, 30)];
            
        }
            break;
        case MessageCellStyleSender: {
            _userPhotoView.frame = CGRectMake(281, kTimeLabelHeight, 34, 34);
            _userPhotoView.layer.cornerRadius = _userPhotoView.bounds.size.width / 2;
            _userPhotoView.layer.masksToBounds = YES;
            
            _contentLabel.frame = CGRectMake(320 - kSmallOffset - size.width - 12, kTimeLabelHeight - 1, size.width, size.height);
            _contentLabel.numberOfLines = 0;
            _backgroundView.frame = CGRectMake(320 - kLargeOffset - size.width - 5, kTimeLabelHeight - 2, size.width + 20, size.height + 1);
            _backgroundView.image = [[UIImage imageNamed:@"sender.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 30, 30, 30)];
        }
            break;
        default:
            break;
    }
    _userPhotoView.image = [UIImage imageNamed:@"placeholder.png"];
}

- (void)setContents:(NSString *)content {
    _contentLabel.text = content;
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

- (CGSize)getContextSizeWithString:(NSString *)string {
    return [string sizeWithFont:_contentLabel.font
              constrainedToSize:CGSizeMake(kMessageBoxWigthMax, CGFLOAT_MAX)
                  lineBreakMode:NSLineBreakByWordWrapping];
}

#pragma mark - 手势

- (void)showContactDetail:(UITapGestureRecognizer *)tap {
    if (self.cellStyle == MessageCellStyleReceive) {
        FXChatViewController *chatC = (FXChatViewController *)self.superview.superview.superview.nextResponder;
        [chatC addDetailView];
    }
}

@end
