//
//  FXBlockedContactInfoView.m
//  FuXin
//
//  Created by lihongliang on 14-6-4.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXBlockedContactInfoView.h"
#import "FXBlockedContactsController.h"

@implementation FXBlockedContactInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *backView = [[UIView alloc] initWithFrame:frame];
        backView.backgroundColor = kColor(120, 120, 120, 0.4);
        [self addSubview:backView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenSelf:)];
        [backView addGestureRecognizer:tap];
        
        _contentBgView = [[UIView alloc] initWithFrame:CGRectMake(15, 30, 290, 112)];
        _contentBgView.backgroundColor = [UIColor whiteColor];
        _contentBgView.layer.cornerRadius = 6;
        _contentBgView.clipsToBounds = YES;
        [backView addSubview:_contentBgView];
        
        _photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 34, 34)];
        _photoImageView.layer.cornerRadius = _photoImageView.bounds.size.height / 2;
        _photoImageView.layer.masksToBounds = YES;
        _photoImageView.image = [UIImage imageNamed:@"placeholder.png"];
        [_contentBgView addSubview:_photoImageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 80, 20)];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.adjustsFontSizeToFitWidth = YES;
        _nameLabel.text = @"王菲菲";
        _nameLabel.minimumScaleFactor = 0.5f;
        [_contentBgView addSubview:_nameLabel];
        
        _genderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(142, 13, 16, 16)];
        _genderImageView.image = [UIImage imageNamed:@"male.png"];
        [_contentBgView addSubview:_genderImageView];
        
        _remarkLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 30, 130, 20)];
        _remarkLabel.backgroundColor = [UIColor clearColor];
        _remarkLabel.font = [UIFont systemFontOfSize:12];
        _remarkLabel.textColor = kColor(150, 150, 150, 1);
        _remarkLabel.text = @"备注：好学生";
        [_contentBgView addSubview:_remarkLabel];
        
        _buttonBgView = [[UIView alloc] initWithFrame:CGRectMake(190, 10, 95, 26)];
        _buttonBgView.backgroundColor = [UIColor clearColor];
        [_contentBgView addSubview:_buttonBgView];
        
        UIButton *tradeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        tradeButton.frame = (CGRect){0 , 0, 30 ,_buttonBgView.frame.size.height * 2 / 3};
//        [tradeButton setImage:[UIImage imageNamed:@"trade.png"] forState:UIControlStateNormal];
        [tradeButton addTarget:self action:@selector(tradeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _tradeButton = tradeButton;
        [_buttonBgView addSubview:tradeButton];
        
        UIButton *subscribeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        subscribeButton.frame = (CGRect){35 , 0, 30 ,_buttonBgView.frame.size.height * 2 / 3};
//        [subscribeButton setImage:[UIImage imageNamed:@"subscription.png"] forState:UIControlStateNormal];
        [subscribeButton addTarget:self action:@selector(subscribeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _subscriptionButton = subscribeButton;
        [_buttonBgView addSubview:subscribeButton];
        
        //line
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 66, 290, 1)];
        line.backgroundColor = kColor(204, 204, 204, 1);
        [_contentBgView addSubview:line];
        
        UIButton *recoverButton = [UIButton buttonWithType:UIButtonTypeCustom];
        recoverButton.frame = CGRectMake(0, 67, 290, 112 - 67);
        [recoverButton setTitleColor:kColor(51, 51, 51, 1) forState:UIControlStateNormal];
        [recoverButton setTitle:@"恢复收听此人" forState:UIControlStateNormal];
        recoverButton.titleLabel.font = [UIFont systemFontOfSize:14];
        recoverButton.backgroundColor = kColor(229, 229, 229, 1);
        [recoverButton addTarget:self action:@selector(recoverButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_contentBgView addSubview:recoverButton];
    }
    return self;
}

- (void)setContact:(ContactModel *)contact {
    _contact = contact;
    [self setValueForUI];
}

- (void)setValueForUI {
    if ([FXFileHelper isHeadImageExist:_contact.contactAvatarURL]) {
        NSData *imageData = [FXFileHelper headImageWithName:_contact.contactAvatarURL];
        _photoImageView.image = [UIImage imageWithData:imageData];
    }
    else {
        _photoImageView.image = [UIImage imageNamed:@"placeholder.png"];
    }
    _nameLabel.text = _contact.contactNickname;
    _remarkLabel.text = _contact.contactRemark;
    
    BOOL showFirst = (_contact.contactRelationship & 3);
    BOOL showSecond = ((_contact.contactRelationship & 12) >> 2);
    [self showOrder:showFirst showSubscribe:showSecond];
}

- (void)hiddenSelf:(UITapGestureRecognizer *)tap {
    CGPoint touchPoint = [tap locationInView:tap.view];
    if (!CGRectContainsPoint(_contentBgView.frame, touchPoint)) {
        [self hiddenContactView];
    }
}

- (void)hiddenContactView {
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 0;
    }completion:^(BOOL finish){
        self.hidden = YES;
    }];
}

- (void)tradeButtonClicked:(UIButton *)sender{
    //交易按钮
}

- (void)subscribeButtonClicked:(UIButton *)sender{
    //订阅按钮
}

- (void)recoverButtonClicked:(UIButton *)sender{
    //恢复收听此人
    if (self.delegate && [self.delegate respondsToSelector:@selector(blockedContactInfoViewRecover:)]) {
        [self.delegate blockedContactInfoViewRecover:self];
        [self hiddenContactView];
    }
}

- (void)showOrder:(BOOL)showFirst showSubscribe:(BOOL)showSecond {
    NSLog(@"%d,%d",showFirst,showSecond);
    if (showFirst) {
        _tradeButton.hidden = NO;
        [_tradeButton setImage:[UIImage imageNamed:@"trade.png"] forState:UIControlStateNormal];
        if (showSecond) {
            _subscriptionButton.hidden = NO;
            [_subscriptionButton setImage:[UIImage imageNamed:@"subscription.png"] forState:UIControlStateNormal];
        }
        else {
            _subscriptionButton.hidden = YES;
        }
    }
    else {
        if (showSecond) {
            _tradeButton.hidden = NO;
            [_tradeButton setImage:[UIImage imageNamed:@"subscription.png"] forState:UIControlStateNormal];
        }
        else {
            _tradeButton.hidden = YES;
        }
        _subscriptionButton.hidden = YES;
    }
}
@end
