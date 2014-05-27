//
//  FXXiuGaiMiMaViewController.h
//  FuXin
//
//  Created by SumFlower on 14-5-26.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FXXiuGaiMiMaViewController : UIViewController<UITextFieldDelegate>
@property (nonatomic, weak)IBOutlet UITextField *oldPassWord;//旧密码
@property (nonatomic, weak)IBOutlet UITextField *nowPassWord;//新密码
@property (nonatomic, weak)IBOutlet UITextField *confirmPassWord;//确认密码
@property (nonatomic, weak)IBOutlet UITextField *yanZhenMa;//验证码

@end
