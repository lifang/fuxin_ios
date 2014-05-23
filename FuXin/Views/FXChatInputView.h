//
//  FXChatInputView.h
//  FuXin
//
//  Created by 徐宝桥 on 14-5-21.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>

//聊天输入框高度
#define kInputViewHeight    40

@protocol GetInputTextDelegate <NSObject>

- (void)getInputText:(NSString *)intputText;

@optional
//键盘出现时view上移
- (void)viewNeedMoveUpWithKeyboardHeight:(CGFloat)height;
//view复位
- (void)viewNeedMoveResetWithKeyBoardHeight:(CGFloat)height;

@end

@interface FXChatInputView : UIView<UITextViewDelegate>

@property (nonatomic, weak) id<GetInputTextDelegate> inputDelegate;

//表情按钮
@property (nonatomic, strong) UIButton *expressButton;

//输入框
@property (nonatomic, strong) UITextView *inputView;

//发送按钮
@property (nonatomic, strong) UIButton *sendButton;

@end
