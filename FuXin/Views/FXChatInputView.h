//
//  FXChatInputView.h
//  FuXin
//
//  Created by 徐宝桥 on 14-5-21.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

//聊天输入框按钮

typedef enum {
    PictureNone = 0,
    PictureEmoji,      //表情按钮
    PicturePhoto,      //图片按钮
}PictureTags;

#import <UIKit/UIKit.h>
#import "FXShowPhotoView.h"

//聊天输入框高度
#define kInputViewHeight    40

@protocol GetInputTextDelegate <NSObject>

//获取输入框文字
- (void)getInputText:(NSString *)intputText;

//获取点击表情和图片按钮事件
- (void)sendActionWithButtonTag:(PictureTags)tag;

@optional

- (void)keyboardWillChangeWithInfo:(NSDictionary *)info;

@end

@interface FXChatInputView : UIView<UITextViewDelegate>

@property (nonatomic, assign) id<GetInputTextDelegate> inputDelegate;

//表情按钮
@property (nonatomic, strong) UIButton *expressButton;

//输入框
@property (nonatomic, strong) UITextView *inputView;

//图片按钮
@property (nonatomic, strong) UIButton *sendButton;

@end
