//
//  FXContactView.m
//  FuXin
//
//  Created by 徐宝桥 on 14-5-29.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXContactView.h"
#import "FXChatViewController.h"

@implementation FXContactView

@synthesize contact = _contact;
@synthesize deskView = _deskView;
@synthesize photoView = _photoView;
@synthesize nameLabel = _nameLabel;
@synthesize sexView = _sexView;
@synthesize remarkLabel = _remarkLabel;
@synthesize remarkField = _remarkField;
@synthesize relationView1 = _relationView1;
@synthesize relationView2 = _relationView2;

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
    UIView *backView = [[UIView alloc] initWithFrame:self.bounds];
    backView.backgroundColor = kColor(120, 120, 120, 0.6);
    [self addSubview:backView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenSelf:)];
    [backView addGestureRecognizer:tap];
    
    _deskView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 300, 250)];
    _deskView.backgroundColor = [UIColor whiteColor];
    _deskView.layer.cornerRadius = 6;
    [backView addSubview:_deskView];
    
    _photoView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 34, 34)];
    _photoView.layer.cornerRadius = _photoView.bounds.size.height / 2;
    _photoView.layer.masksToBounds = YES;
    _photoView.image = [UIImage imageNamed:@"placeholder.png"];
    [_deskView addSubview:_photoView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 140, 20)];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.font = [UIFont boldSystemFontOfSize:14];
    _nameLabel.adjustsFontSizeToFitWidth = YES;
    _nameLabel.minimumScaleFactor = 0.5f;
    [_deskView addSubview:_nameLabel];
    
    _sexView = [[UIImageView alloc] initWithFrame:CGRectMake(200, 10, 16, 16)];
    [_deskView addSubview:_sexView];
    
    _relationView1 = [[UIImageView alloc] initWithFrame:CGRectMake(227, 11, 27, 15)];
    _relationView1.image = [UIImage imageNamed:@"trade.png"];
    _relationView1.hidden = YES;
    [_deskView addSubview:_relationView1];
    
    _relationView2 = [[UIImageView alloc] initWithFrame:CGRectMake(259, 11, 27, 15)];
    _relationView2.image = [UIImage imageNamed:@"subscription.png"];
    _relationView2.hidden = YES;
    [_deskView addSubview:_relationView2];
    
    _remarkLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 30, 200, 20)];
    _remarkLabel.backgroundColor = [UIColor clearColor];
    _remarkLabel.font = [UIFont systemFontOfSize:12];
    _remarkLabel.textColor = kColor(150, 150, 150, 1);
    [_deskView addSubview:_remarkLabel];
    
    
    int count = 4;
    if (!_contact.contactIsProvider) {
        CGRect rect = _deskView.frame;
        rect.size.height = 100;
        _deskView.frame = rect;
        count = 1;
    }
    //line 是福师显示认证行业和个人简介，不是福师不显示
    for (int i = 1; i <= count; i++) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, i * 48, 280, 1)];
        line.backgroundColor = kColor(200, 200, 200, 1);
        [_deskView addSubview:line];
        
        [self addTitleLabelWithInt:i];
    }
    
    _remarkField = [[UITextField alloc] initWithFrame:CGRectMake(85, 59, 140, 30)];
    _remarkField.borderStyle = UITextBorderStyleNone;
    _remarkField.font = [UIFont systemFontOfSize:14];
    _remarkField.placeholder = @"备注";
    _remarkField.textColor = kColor(150, 150, 150, 1);
    _remarkField.returnKeyType = UIReturnKeyDone;
    _remarkField.delegate = self;
    [_deskView addSubview:_remarkField];
    
    UIView *lineBottom = [[UIView alloc] initWithFrame:CGRectMake(85, 89, 140, 1)];
    lineBottom.backgroundColor = [UIColor blackColor];
    [_deskView addSubview:lineBottom];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    sureBtn.frame = CGRectMake(236, 58, 50, 30);
    sureBtn.layer.cornerRadius = 4;
    sureBtn.layer.borderWidth = 1;
    [sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(modifyContactInfo:) forControlEvents:UIControlEventTouchUpInside];
    [_deskView addSubview:sureBtn];
}

- (void)addTitleLabelWithInt:(int)index {
    NSString *title = nil;
    switch (index) {
        case 1:
            title = @"设置备注：";
            break;
        case 2:
            title = @"福值：";
            break;
        case 3:
            title = @"认证行业：";
            break;
        case 4:
            title = @"个人简介：";
            break;
        default:
            break;
    }
    UILabel *title1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 15 + 48 * index, 100, 20)];
    title1.backgroundColor = [UIColor clearColor];
    title1.font = [UIFont boldSystemFontOfSize:14];
    title1.text = title;
    [_deskView addSubview:title1];
    
    if (index >= 2) {
        UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(85, 6 + 48 * index, 180 ,40)];
        content.backgroundColor = [UIColor clearColor];
        content.font = [UIFont systemFontOfSize:14];
        content.adjustsFontSizeToFitWidth = YES;
        content.minimumScaleFactor = 0.5f;
        content.numberOfLines = 2;
        content.textColor = kColor(150 , 150, 150, 1);
        content.tag = index;
        content.text = title;
        [_deskView addSubview:content];
    }
}

- (void)setContact:(ContactModel *)contact {
    _contact = contact;
    [self setValueForUI];
}

- (void)setValueForUI {
    if ([FXFileHelper isHeadImageExist:_contact.contactAvatarURL]) {
        NSData *imageData = [FXFileHelper headImageWithName:_contact.contactAvatarURL];
        _photoView.image = [UIImage imageWithData:imageData];
    }
    else {
        _photoView.image = [UIImage imageNamed:@"placeholder.png"];
    }
    _nameLabel.text = _contact.contactNickname;
    _remarkLabel.text = _contact.contactRemark;
    _remarkField.placeholder = _contact.contactRemark;
    
    if (_contact.contactSex == ContactSexMale) {
        _sexView.image = [UIImage imageNamed:@"male.png"];
    }
    else if (_contact.contactSex == ContactSexFemale) {
        _sexView.image = [UIImage imageNamed:@"female.png"];
    }
    else if (_contact.contactSex == ContactSexSecret) {

    }
    
    UILabel *fuzhi = (UILabel *)[self viewWithTag:2];
    fuzhi.text = _contact.fuzhi;
    
    UILabel *professsion = (UILabel *)[self viewWithTag:3];
    professsion.text = _contact.contactLisence;
    
    UILabel *sign = (UILabel *)[self viewWithTag:4];
    sign.text = _contact.contactSignature;
    
    BOOL showFirst = (_contact.contactRelationship & 3);
    BOOL showSecond = ((_contact.contactRelationship & 12) >> 2);
    if (!showFirst) {
        _relationView1.hidden = NO;
    }
    if (!showSecond) {
        _relationView2.hidden = NO;
    }
}

- (IBAction)modifyContactInfo:(id)sender {
    [_remarkField resignFirstResponder];
    FXChatViewController *chatC = (FXChatViewController *)self.superview.nextResponder;
    [chatC modifyContactRemark:_remarkField.text];
}

- (void)hiddenSelf:(UITapGestureRecognizer *)tap {
    [_remarkField resignFirstResponder];
    CGPoint touchPoint = [tap locationInView:tap.view];
    if (!CGRectContainsPoint(_deskView.frame, touchPoint)) {
        [self hiddenContactView];
    }
}

- (void)hiddenContactView {
    [_remarkField resignFirstResponder];
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    }completion:^(BOOL finish){
        self.hidden = YES;
    }];
}

#pragma mark -

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
