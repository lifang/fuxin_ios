//
//  FXContactDetailView.m
//  FuXin
//
//  Created by 徐宝桥 on 14-6-24.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXContactDetailView.h"

@implementation FXContactDetailView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _photoView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 40, 40)];
    _photoView.layer.cornerRadius = _photoView.bounds.size.width / 2;
    _photoView.layer.masksToBounds = YES;
    [self addSubview:_photoView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 20, 160, 20)];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.font = [UIFont boldSystemFontOfSize:16];
    [self addSubview:_nameLabel];
    
    _sexView = [[UIImageView alloc] initWithFrame:CGRectMake(60, 52, 16, 16)];
    [self addSubview:_sexView];
    
    _relationView1 = [[UIImageView alloc] initWithFrame:CGRectMake(85, 52, 27, 15)];
    _relationView1.image = [UIImage imageNamed:@"trade.png"];
    _relationView1.hidden = YES;
    [self addSubview:_relationView1];
    
    _relationView2 = [[UIImageView alloc] initWithFrame:CGRectMake(120, 52, 27, 15)];
    _relationView2.image = [UIImage imageNamed:@"subscription.png"];
    _relationView2.hidden = YES;
    [self addSubview:_relationView2];
}

- (void)setContact:(ContactModel *)contact {
    if ([FXFileHelper isHeadImageExist:contact.contactAvatarURL]) {
        NSData *imageData = [FXFileHelper headImageWithName:contact.contactAvatarURL];
        _photoView.image = [UIImage imageWithData:imageData];
    }
    else {
        _photoView.image = [UIImage imageNamed:@"placeholder.png"];
    }
    _nameLabel.text = contact.contactNickname;

    if (contact.contactSex == ContactSexMale) {
        _sexView.image = [UIImage imageNamed:@"male.png"];
    }
    else if (contact.contactSex == ContactSexFemale) {
        _sexView.image = [UIImage imageNamed:@"female.png"];
    }
    else if (contact.contactSex == ContactSexSecret) {
        
    }
    
    BOOL showFirst = (contact.contactRelationship & 3);
    BOOL showSecond = ((contact.contactRelationship & 12) >> 2);
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
