//
//  FXContactCell.m
//  FuXin
//
//  Created by 徐宝桥 on 14-6-17.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXContactCell.h"

@implementation FXContactCell

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
    [self.contentView addSubview:_nameLabel];
 
    _remarkLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 25, 250, 20)];
    _remarkLabel.backgroundColor = [UIColor clearColor];
    _remarkLabel.font = [UIFont systemFontOfSize:12];
    _remarkLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:_remarkLabel];
    
    _sexView = [[UIImageView alloc] initWithFrame:CGRectMake(210, 9, 16, 16)];
    [self.contentView addSubview:_sexView];
}

@end
