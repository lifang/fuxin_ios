//
//  FXAddressListCell.m
//  FuXin
//
//  Created by 徐宝桥 on 14-5-25.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXAddressListCell.h"

@implementation FXAddressListCell

@synthesize photoView = _photoView;
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
    _photoView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 34, 34)];
    _photoView.layer.cornerRadius = _photoView.bounds.size.width / 2;
    _photoView.layer.masksToBounds = YES;
    _photoView.image = [UIImage imageNamed:@"placeholder.png"];
    [self.contentView addSubview:_photoView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 12, 100, 20)];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textColor = [UIColor blackColor];
    _nameLabel.font = [UIFont boldSystemFontOfSize:14];
    [self.contentView addSubview:_nameLabel];
    
    
}

@end
