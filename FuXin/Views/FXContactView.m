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
    backView.backgroundColor = kColor(120, 120, 120, 0.4);
    [self addSubview:backView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenSelf:)];
    [backView addGestureRecognizer:tap];
    
    _deskView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 300, 240)];
    _deskView.backgroundColor = [UIColor whiteColor];
    _deskView.layer.cornerRadius = 6;
    [backView addSubview:_deskView];
    
    _photoView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 34, 34)];
    _photoView.layer.cornerRadius = _photoView.bounds.size.height / 2;
    _photoView.layer.masksToBounds = YES;
    _photoView.image = [UIImage imageNamed:@"placeholder.png"];
    [_deskView addSubview:_photoView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 100, 20)];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.font = [UIFont boldSystemFontOfSize:14];
    _nameLabel.adjustsFontSizeToFitWidth = YES;
    _nameLabel.text = @"王菲菲";
    _nameLabel.minimumScaleFactor = 0.5f;
    [_deskView addSubview:_nameLabel];
    
    _sexView = [[UIImageView alloc] initWithFrame:CGRectMake(180, 10, 16, 16)];
    _sexView.image = [UIImage imageNamed:@"male.png"];
    [_deskView addSubview:_sexView];
    
    _remarkLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 30, 200, 20)];
    _remarkLabel.backgroundColor = [UIColor clearColor];
    _remarkLabel.font = [UIFont systemFontOfSize:12];
    _remarkLabel.textColor = kColor(150, 150, 150, 1);
    _remarkLabel.text = @"备注：好学生";
    [_deskView addSubview:_remarkLabel];
    
    //line
    for (int i = 1; i <= 4; i++) {
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
    sureBtn.frame = CGRectMake(235, 57, 52, 32);
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
            title = @"认证行业：";
            break;
        case 3:
            title = @"开课类型：";
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
        UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(85, 15 + 48 * index, 180 ,20)];
        content.backgroundColor = [UIColor clearColor];
        content.font = [UIFont systemFontOfSize:14];
        content.adjustsFontSizeToFitWidth = YES;
        content.minimumScaleFactor = 0.5f;
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
    if (_contact.contactAvatar && [_contact.contactAvatar length] > 0) {
        _photoView.image = [UIImage imageWithData:_contact.contactAvatar];
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
    
    UILabel *professsion = (UILabel *)[self viewWithTag:2];
    professsion.text = _contact.contactLisence;
    
    UILabel *class = (UILabel *)[self viewWithTag:3];
    class.text = _contact.contactPublishClassType;
    
    UILabel *sign = (UILabel *)[self viewWithTag:4];
    sign.text = _contact.contactSignature;
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
