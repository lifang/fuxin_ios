//
//  FXReviewController.h
//  FuXin
//
//  Created by 徐宝桥 on 14-5-19.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXAdjustViewController.h"
#import "FXInputView.h"

@interface FXReviewController : FXAdjustViewController

//手机号码
@property (nonatomic, strong) FXInputView *phoneView;
//验证码
@property (nonatomic, strong) FXInputView *codeView;
//手机号，上一界面传入
@property (nonatomic, strong) NSString *phoneNumber;

@end
