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
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 20, 150, 20)];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.font = [UIFont boldSystemFontOfSize:16];
    [self addSubview:_nameLabel];
    
    _sexView = [[UIImageView alloc] initWithFrame:CGRectMake(65, 51, 12, 12)];
    [self addSubview:_sexView];
    
    //按钮
    _infoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _infoButton.frame = CGRectMake(90, 50, 14, 14);
    _infoButton.tag = UserBtnInfo;
    _infoButton.hidden = YES;
    _infoButton.userInteractionEnabled = NO;
    [_infoButton setImage:[UIImage imageNamed:@"signal.png"] forState:UIControlStateNormal];
    [_infoButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_infoButton];
    
    _msgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _msgButton.frame = CGRectMake(115, 50, 14, 14);
    _msgButton.tag = UserBtnMessage;
    _msgButton.hidden = YES;
    _msgButton.userInteractionEnabled = NO;
    [_msgButton setImage:[UIImage imageNamed:@"text_msg.png"] forState:UIControlStateNormal];
    [_msgButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_msgButton];
    
    _phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _phoneButton.frame = CGRectMake(140, 50, 14, 14);
    _phoneButton.tag = UserBtnPhone;
    _phoneButton.hidden = YES;
    _phoneButton.userInteractionEnabled = NO;
    [_phoneButton setImage:[UIImage imageNamed:@"phone_icon.png"] forState:UIControlStateNormal];
    [_phoneButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_phoneButton];
}

- (void)showRealName:(BOOL)showReal showMessage:(BOOL)showMsg showPhone:(BOOL)showPhone {
    CGRect rect1 = CGRectMake(90, 50, 14, 14);
    CGRect rect2 = CGRectMake(115, 50, 14, 14);
    CGRect rect3 = CGRectMake(140, 50, 14, 14);
    if (showReal) {
        _infoButton.hidden = NO;
        _infoButton.frame = rect1;
        if (showMsg) {
            _msgButton.hidden = NO;
            _msgButton.frame = rect2;
            if (showPhone) {
                _phoneButton.hidden = NO;
                _phoneButton.frame = rect3;
            }
            else {
                _phoneButton.hidden = YES;
            }
        }
        else {
            _msgButton.hidden = YES;
            if (showPhone) {
                _phoneButton.hidden = NO;
                _phoneButton.frame = rect2;
            }
            else {
                _phoneButton.hidden = YES;
            }
        }
    }
    else {
        _infoButton.hidden = YES;
        if (showMsg) {
            _msgButton.hidden = NO;
            _msgButton.frame = rect1;
            if (showPhone) {
                _phoneButton.hidden = NO;
                _phoneButton.frame = rect2;
            }
            else {
                _phoneButton.hidden = YES;
            }
        }
        else {
            _msgButton.hidden = YES;
            if (showPhone) {
                _phoneButton.hidden = NO;
                _phoneButton.frame = rect1;
            }
            else {
                _phoneButton.hidden = YES;
            }
        }
    }
}

- (IBAction)btnClick:(id)sender {
    
}

@end
