//
//  FXChatCell.m
//  FuXin
//
//  Created by 徐宝桥 on 14-5-20.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXChatCell.h"

@implementation FXChatCell

@synthesize photoView = _photoView;
@synthesize numberLabel = _numberLabel;
@synthesize nameLabel = _nameLabel;
@synthesize timeLabel = _timeLabel;
@synthesize detailLabel = _detailLabel;
@synthesize backView = _backView;

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
    _photoView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 34, 34)];
    _photoView.layer.cornerRadius = _photoView.bounds.size.width / 2;
    _photoView.layer.masksToBounds = YES;
    [self.contentView addSubview:_photoView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, 150, 20)];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.font = [UIFont boldSystemFontOfSize:14];
    _nameLabel.adjustsFontSizeToFitWidth = YES;
    _nameLabel.minimumScaleFactor = 0.7f;
    _nameLabel.textColor = kColor(70, 154, 211, 1);
    [self.contentView addSubview:_nameLabel];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(220, 5, 60, 20)];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.font = [UIFont systemFontOfSize:10];
    _timeLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_timeLabel];
    
    _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 25, 250, 20)];
    _detailLabel.backgroundColor = [UIColor clearColor];
    _detailLabel.font = [UIFont systemFontOfSize:14];
    _detailLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:_detailLabel];
    
    
    _backView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 6, 18, 18)];
    _backView.image = [UIImage imageNamed:@"messnum.png"];
    [self.contentView addSubview:_backView];
    
    _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 2, 14, 14)];
    _numberLabel.backgroundColor = [UIColor clearColor];
    _numberLabel.font = [UIFont systemFontOfSize:10];
    _numberLabel.textColor = [UIColor whiteColor];
    _numberLabel.textAlignment = NSTextAlignmentCenter;
    _numberLabel.layer.masksToBounds = YES;
    [_backView addSubview:_numberLabel];
}

- (void)setNumber:(NSString *)number {
    _backView.hidden = NO;
    if (number.length >= 3) {
        _numberLabel.font = [UIFont systemFontOfSize:7];
        _numberLabel.text = @"99+";
    }
    else {
        _numberLabel.font = [UIFont systemFontOfSize:10];
        _numberLabel.text = number;
        if (number == nil || [number isEqualToString:@""]) {
            _backView.hidden = YES;
        }
    }
}

@end
