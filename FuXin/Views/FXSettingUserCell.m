//
//  FXSettingUserCell.m
//  FuXin
//
//  Created by 徐宝桥 on 14-6-2.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXSettingUserCell.h"

@implementation FXSettingUserCell

@synthesize photoView = _photoView;
@synthesize nameLabel = _nameLabel;
@synthesize sexView = _sexView;
@synthesize infoButton = _infoButton;
@synthesize msgButton = _msgButton;
@synthesize phoneButton = _phoneButton;

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
    _photoView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 34, 34)];
    _photoView.layer.cornerRadius = _photoView.frame.size.width / 2;
    _photoView.layer.masksToBounds = YES;
    [self addSubview:_photoView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 20, 100, 20)];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.font = [UIFont boldSystemFontOfSize:16];
    [self addSubview:_nameLabel];
    
    _sexView = [[UIImageView alloc] initWithFrame:CGRectMake(170, 24, 12, 12)];
    [self addSubview:_sexView];
    
    //按钮
    _infoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _infoButton.frame = CGRectMake(65, 50, 14, 14);
    _infoButton.tag = UserBtnInfo;
    [_infoButton setImage:[UIImage imageNamed:@"signal.png"] forState:UIControlStateNormal];
    [_infoButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_infoButton];
    
    _msgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _msgButton.frame = CGRectMake(90, 50, 14, 14);
    _msgButton.tag = UserBtnMessage;
    [_msgButton setImage:[UIImage imageNamed:@"text_msg.png"] forState:UIControlStateNormal];
    [_msgButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_msgButton];
    
    _phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _phoneButton.frame = CGRectMake(115, 50, 14, 14);
    _phoneButton.tag = UserBtnPhone;
    [_phoneButton setImage:[UIImage imageNamed:@"phone_icon.png"] forState:UIControlStateNormal];
    [_phoneButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_phoneButton];
}

- (IBAction)btnClick:(id)sender {
    
}

@end
