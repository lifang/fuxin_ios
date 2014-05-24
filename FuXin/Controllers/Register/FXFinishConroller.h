//
//  FXFinishConroller.h
//  FuXin
//
//  Created by 徐宝桥 on 14-5-19.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXAdjustViewController.h"
#import "FXInputView.h"

@interface FXFinishConroller : FXAdjustViewController

//昵称
@property (nonatomic, strong) FXInputView *nameField;
//密码
@property (nonatomic, strong) FXInputView *passwordField;

@property (nonatomic, strong) FXInputView *repeatField;

@end
