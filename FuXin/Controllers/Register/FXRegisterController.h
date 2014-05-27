//
//  FXRegisterController.h
//  FuXin
//
//  Created by 徐宝桥 on 14-5-19.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXAdjustViewController.h"
#import "FXInputView.h"

//typedef enum {
//    RegisterInput = 0,  //输入手机号界面
//    RegisterReview,     //验证码界面
//    RegisterFinish,     //注册完成界面
//}RegisterViews;

@interface FXRegisterController : FXAdjustViewController<UITableViewDataSource ,UITableViewDelegate ,UITextFieldDelegate>

//第一步 填写手机号码
@property (nonatomic, strong) FXInputView *phoneView;

@end
