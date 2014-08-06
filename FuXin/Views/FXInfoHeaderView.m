//
//  FXInfoHeaderView.m
//  FuXin
//
//  Created by 徐宝桥 on 14-7-16.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXInfoHeaderView.h"

@implementation FXInfoHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    _backView.backgroundColor = [UIColor whiteColor];
    _backView.image = [UIImage imageNamed:@"background1.png"];
    [self addSubview:_backView];
    
    _photoView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 60, 70, 70)];
    _photoView.layer.borderColor = [UIColor whiteColor].CGColor;
    _photoView.layer.borderWidth = 2;
    _photoView.layer.masksToBounds = YES;
    _photoView.layer.cornerRadius = 10;
    [self addSubview:_photoView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 110, 200, 20)];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.font = [UIFont boldSystemFontOfSize:15];
    [self addSubview:_nameLabel];
    
    _detailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self addSubview:_detailLabel];
    
    _modifyBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [self addSubview:_modifyBtn];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.origin.y + self.frame.size.height - 1, 320, 1)];
    line.backgroundColor = kColor(200, 200, 200, 1);
    [self addSubview:line];
}

- (void)setContact:(ContactModel *)contact {
    if ([FXFileHelper isHeadImageExist:contact.backgroundURL]) {
        UIImage *backImage = [UIImage imageWithData:[FXFileHelper headImageWithName:contact.backgroundURL]];
        if (backImage) {
            _backView.image = backImage;
        }
    }
    
    if ([FXFileHelper isHeadImageExist:contact.contactAvatarURL]) {
        NSData *imageData = [FXFileHelper headImageWithName:contact.contactAvatarURL];
        _photoView.image = [UIImage imageWithData:imageData];
    }
    else {
        _photoView.image = [UIImage imageNamed:@"placeholder.png"];
    }
    if (contact.contactRemark && ![contact.contactRemark isEqualToString:@""]) {
        _nameLabel.text = contact.contactRemark;
    }
    else {
        _nameLabel.text = contact.contactNickname;
    }
}

- (void)setUser:(FXUserModel *)user {
    _detailLabel.backgroundColor = [UIColor clearColor];
    _detailLabel.textColor = [UIColor grayColor];
    _detailLabel.font = [UIFont systemFontOfSize:13];
    
    if ([FXFileHelper isHeadImageExist:user.backgroundURL]) {
        UIImage *backImage = [UIImage imageWithData:[FXFileHelper headImageWithName:user.backgroundURL]];
        if (backImage) {
            _backView.image = backImage;
        }
    }
    
    [_modifyBtn setBackgroundImage:[UIImage imageNamed:@"pen.png"] forState:UIControlStateNormal];
    
    if (user.tile && [user.tile length] > 1) {
        _photoView.image = [UIImage imageWithData:user.tile];
    }
    else {
        _photoView.image = [UIImage imageNamed:@"placeholder.png"];
    }
    _nameLabel.text = user.name;
    [_nameLabel sizeToFit];
    CGRect rect = _nameLabel.frame;
    if (rect.size.width > 80) {
        rect.size.width = 80;
    }
    _nameLabel.frame = rect;
    
    _detailLabel.frame = CGRectMake(rect.origin.x + rect.size.width + 5, 112, 100, 20);
    _detailLabel.text = user.nickName;
    [_detailLabel sizeToFit];
    rect = _detailLabel.frame;
    if (rect.size.width > 100) {
        rect.size.width = 100;
    }
    _detailLabel.frame = rect;
    _modifyBtn.frame = CGRectMake(rect.origin.x + rect.size.width + 5, 110, 18, 18);
}


@end
