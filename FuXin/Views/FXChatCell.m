//
//  FXChatCell.m
//  FuXin
//
//  Created by 徐宝桥 on 14-5-20.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXChatCell.h"

@implementation FXChatCell

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
    self.photoView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 40, 40)];
    self.photoView.layer.cornerRadius = self.photoView.bounds.size.width / 2;
    self.photoView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.photoView];
    
    _blockView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 45, 10, 10)];
    [self.contentView addSubview:_blockView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 15, 140, 20)];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.font = [UIFont boldSystemFontOfSize:16];
//    _nameLabel.adjustsFontSizeToFitWidth = YES;
//    _nameLabel.minimumScaleFactor = 0.7f;
//    _nameLabel.textColor = kColor(70, 154, 211, 1);
    _nameLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_nameLabel];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(201, 15, 118, 20)];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.font = [UIFont systemFontOfSize:14];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    _timeLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_timeLabel];
    
    _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 35, 240, 20)];
    _detailLabel.backgroundColor = [UIColor clearColor];
    _detailLabel.font = [UIFont systemFontOfSize:14];
    _detailLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:_detailLabel];
    
    
    _backView = [[UIImageView alloc] initWithFrame:CGRectMake(36, 10, 18, 18)];
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
    _numberLabel.hidden = NO;
    if (number.length >= 3) {
        _numberLabel.font = [UIFont systemFontOfSize:7];
        _numberLabel.text = @"99+";
    }
    else {
        _numberLabel.font = [UIFont systemFontOfSize:10];
        _numberLabel.text = number;
        if (number == nil || [number isEqualToString:@""] || [number isEqualToString:@"0"]) {
            _backView.hidden = YES;
            _numberLabel.hidden = YES;
        }
    }
}

@end
