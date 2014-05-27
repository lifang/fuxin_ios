//
//  FXMessageBoxCell.m
//  FuXin
//
//  Created by 徐宝桥 on 14-5-21.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXMessageBoxCell.h"

#define kMessageBoxHeightMin  36

#define kLargeOffset        55
#define kSmallOffset        40

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
    _backgroundView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _contentLabel.backgroundColor = [UIColor clearColor];
    _contentLabel.font = [UIFont systemFontOfSize:14];
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _timeLabel.backgroundColor = [UIColor clearColor];
    
    [self.contentView addSubview:_userPhotoView];
    [self.contentView addSubview:_backgroundView];
    [self.contentView addSubview:_contentLabel];
    [self.contentView addSubview:_timeLabel];
    
    UIView *backView = [[UIView alloc] initWithFrame:self.frame];
    backView.backgroundColor = [UIColor clearColor];
    self.selectedBackgroundView = backView;
}

- (void)setSubviewsFrame {
    CGSize size = [self getContextSizeWithString:_contentLabel.text];
    size.height = size.height > kMessageBoxHeightMin ? size.height : kMessageBoxHeightMin;
    switch (_cellStyle) {
        case MessageCellStyleReceive: {
            _userPhotoView.frame = CGRectMake(5, 8, 34, 34);
            _userPhotoView.layer.cornerRadius = _userPhotoView.bounds.size.width / 2;
            _userPhotoView.layer.masksToBounds = YES;
            
            _contentLabel.frame = CGRectMake(kLargeOffset, 6, size.width , size.height);
            _contentLabel.numberOfLines = 0;
            _backgroundView.frame = CGRectMake(kSmallOffset, 5, size.width + 20, size.height + 4);
            _backgroundView.image = [[UIImage imageNamed:@"receive.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 30, 30, 30)];
            
        }
            break;
        case MessageCellStyleSender: {
            _userPhotoView.frame = CGRectMake(281, 5, 34, 34);
            _userPhotoView.layer.cornerRadius = _userPhotoView.bounds.size.width / 2;
            _userPhotoView.layer.masksToBounds = YES;
            
            _contentLabel.frame = CGRectMake(320 - kSmallOffset - size.width - 12, 6, size.width, size.height);
            _contentLabel.numberOfLines = 0;
            _backgroundView.frame = CGRectMake(320 - kLargeOffset - size.width - 5, 5, size.width + 20, size.height + 4);
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

@end
