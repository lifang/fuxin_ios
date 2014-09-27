//
//  FXAddressListCell.m
//  FuXin
//
//  Created by 徐宝桥 on 14-5-25.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXAddressListCell.h"

@implementation FXAddressListCell

@synthesize nameLabel = _nameLabel;
@synthesize relationView1 = _relationView1;
@synthesize relationView2 = _relationView2;

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
    self.photoView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    self.photoView.layer.cornerRadius = self.photoView.bounds.size.width / 2;
    self.photoView.layer.masksToBounds = YES;
//    _photoView.image = [UIImage imageNamed:@"placeholder.png"];
    [self.contentView addSubview:self.photoView];
    
    _blockView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 40, 10, 10)];
    [self.contentView addSubview:_blockView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 20, 200, 20)];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textColor = [UIColor blackColor];
    _nameLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.contentView addSubview:_nameLabel];
    
    _relationView1 = [[UIImageView alloc] initWithFrame:CGRectMake(215, 32, 30, 16)];
    [self.contentView addSubview:_relationView1];
    
    _relationView2 = [[UIImageView alloc] initWithFrame:CGRectMake(250, 32, 30, 16)];
    [self.contentView addSubview:_relationView2];
}

- (void)showOrder:(BOOL)showFirst showSubscribe:(BOOL)showSecond {
    if (showFirst) {
        _relationView1.hidden = NO;
        _relationView1.image = [UIImage imageNamed:@"trade.png"];
        if (showSecond) {
            _relationView2.hidden = NO;
            _relationView2.image = [UIImage imageNamed:@"subscription.png"];
        }
        else {
            _relationView2.hidden = YES;
        }
    }
    else {
        if (showSecond) {
            _relationView1.hidden = NO;
            _relationView1.image = [UIImage imageNamed:@"subscription.png"];
        }
        else {
            _relationView1.hidden = YES;
        }
        _relationView2.hidden = YES;
    }
}

@end
