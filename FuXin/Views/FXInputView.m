//
//  FXInputView.m
//  FuXin
//
//  Created by 徐宝桥 on 14-5-19.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXInputView.h"

#define kTextFieldHeight  36    //输入框高度

@implementation FXInputView

@synthesize contentField = _contentField;
@synthesize showTopBorder = _showTopBorder;
@synthesize showBottomBorder = _showBottomBorder;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code]
        [self initUI];
    }
    return self;
}

//是否添加上边界线
- (void)setShowTopBorder:(BOOL)showTopBorder {
    _showTopBorder = showTopBorder;
    if (_showTopBorder) {
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
        topView.backgroundColor = [UIColor grayColor];
        topView.alpha = 0.2;
        [self addSubview:topView];
    }
}

//是否添加下边界线
- (void)setShowBottomBorder:(BOOL)showBottomBorder {
    _showBottomBorder = showBottomBorder;
    if (_showBottomBorder) {
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1)];
        bottomView.backgroundColor = [UIColor grayColor];
        bottomView.alpha = 0.2;
        [self addSubview:bottomView];
    }
}

- (void)initUI {
//*******根据view高度判断输入框Y轴偏移量及高度*******************
    CGFloat originY = 0;
    CGFloat fieldHeight = kTextFieldHeight;
    if (self.frame.size.height > kTextFieldHeight) {
        originY = (self.frame.size.height - kTextFieldHeight ) / 2;
    }
    else {
        fieldHeight = self.frame.size.height;
    }
//**********************************************************
    _contentField = [[UITextField alloc] initWithFrame:CGRectMake(20, originY + 2, 280, fieldHeight)];
    _contentField.returnKeyType = UIReturnKeyDone;
    _contentField.borderStyle = UITextBorderStyleNone;
    _contentField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _contentField.delegate = self;
    [self addSubview:_contentField];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
