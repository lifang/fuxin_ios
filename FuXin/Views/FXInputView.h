//
//  FXInputView.h
//  FuXin
//
//  Created by 徐宝桥 on 14-5-19.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

/*
 注册界面view
 必包含一个输入框
 可能包含状态提示框
 */

#import <UIKit/UIKit.h>

@interface FXInputView : UIView<UITextFieldDelegate>

//内容栏，用户输入信息
@property (nonatomic, strong) UITextField *contentField;

//是否显示上边界线
@property (nonatomic, assign, setter = setShowTopBorder:) BOOL showTopBorder;
//是否显示下边界线
@property (nonatomic, assign, setter = setShowBottomBorder:) BOOL showBottomBorder;


@end
