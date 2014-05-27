//
//  FXChatInputView.m
//  FuXin
//
//  Created by 徐宝桥 on 14-5-21.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXChatInputView.h"

@implementation FXChatInputView

@synthesize inputDelegate = _inputDelegate;
@synthesize expressButton = _expressButton;
@synthesize inputView = _inputView;
@synthesize sendButton = _sendButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initUI];
        [self registerKeyboardNotification];
    }
    return self;
}


- (void)initUI {
    self.backgroundColor = kColor(250, 250, 250, 1);
    //上边界
    UIView *topBorder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
    topBorder.backgroundColor = kColor(206, 206, 206, 1);
    [self addSubview:topBorder];
    
    _expressButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _expressButton.frame = CGRectMake(10, 5, 30, 30);
    _expressButton.tag = PictureEmoji;
    [_expressButton setBackgroundImage:[UIImage imageNamed:@"express.png"] forState:UIControlStateNormal];
    [_expressButton setBackgroundImage:[UIImage imageNamed:@"express_selected.png"] forState:UIControlStateHighlighted];
    [_expressButton addTarget:self action:@selector(showPicture:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_expressButton];
    
    //下划线
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(50, 37, 215, 1)];
    bottomLine.backgroundColor = kColor(151, 151, 151, 1);
    [self addSubview:bottomLine];
    
    _inputView = [[UITextView alloc] initWithFrame:CGRectMake(50, 2, 215, 35)];
    _inputView.delegate = self;
    _inputView.returnKeyType = UIReturnKeyDone;
    _inputView.backgroundColor = [UIColor clearColor];
    _inputView.font = [UIFont systemFontOfSize:14];
    [self addSubview:_inputView];
    
    _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendButton.frame = CGRectMake(280, 5, 30, 30);
    _sendButton.tag = PicturePhoto;
    [_sendButton setBackgroundImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
    [_sendButton setBackgroundImage:[UIImage imageNamed:@"addselected.png"] forState:UIControlStateHighlighted];
    [_sendButton addTarget:self action:@selector(showPicture:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_sendButton];
}

#pragma mark - 键盘

- (void)registerKeyboardNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChange:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
}

- (void)keyboardWillChange:(NSNotification *)notification {
    if (_inputDelegate && [_inputDelegate respondsToSelector:@selector(keyboardWillChangeWithInfo:)]) {
        [_inputDelegate keyboardWillChangeWithInfo:notification.userInfo];
    }
}

#pragma mark - Action

//点击表情按钮
- (IBAction)showPicture:(id)sender {
    if (_inputDelegate && [_inputDelegate respondsToSelector:@selector(sendActionWithButtonTag:)]) {
        [_inputDelegate sendActionWithButtonTag:[(UIButton *)sender tag]];
    }
}

//发送消息
- (IBAction)sendMessage:(id)sender {
    [_inputView resignFirstResponder];
    if (_inputDelegate && [_inputDelegate respondsToSelector:@selector(getInputText:)]) {
        [_inputDelegate getInputText:_inputView.text];
    }
    _inputView.text = @"";
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        [self sendMessage:nil];
        return NO;
    }
    return YES;
}

@end
