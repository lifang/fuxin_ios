//
//  FXBlockedContactCell.m
//  FuXin
//
//  Created by lihongliang on 14-6-3.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXBlockedContactCell.h"

@implementation FXBlockedContactCell

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
    _nameLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_nameLabel];
    
    _recoverButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _recoverButton.frame = CGRectMake(290 - 64 - 19, (self.frame.size.height - 31 ) / 2, 64, 31);
    _recoverButton.layer.borderColor = kColor(51, 51, 51, 1).CGColor;
    _recoverButton.layer.borderWidth = .6;
    _recoverButton.titleLabel.font = [UIFont systemFontOfSize:13.];
    _recoverButton.layer.cornerRadius = 6.;
    _recoverButton.backgroundColor = [UIColor clearColor];
    [_recoverButton setTitleColor:kColor(51, 51, 51, 1) forState:UIControlStateNormal];
    [_recoverButton setTitle:@"恢复" forState:UIControlStateNormal];
    [_recoverButton addTarget:self action:@selector(recoverButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_recoverButton];
}

- (void)setContactModel:(ContactModel *)contactModel{
    if (_contactModel == contactModel) {
        return;
    }
    _contactModel = contactModel;
    if (contactModel.contactAvatar.length > 0) {
        UIImage *avatarImg = [UIImage imageWithData:contactModel.contactAvatar];
        [_photoView setImage:avatarImg];
    }
    if (contactModel.contactRemark && ![contactModel.contactRemark isEqualToString:@""]) {
        _nameLabel.text = contactModel.contactRemark;
    }
    else {
        _nameLabel.text = contactModel.contactNickname;
    }
}

- (void)recoverButtonClicked:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(blockedContactCell:recoverContact:)]) {
        [self.delegate blockedContactCell:self recoverContact:self.contactModel];
    }
}

@end
