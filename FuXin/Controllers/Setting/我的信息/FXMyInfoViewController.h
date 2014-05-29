//
//  FXMyInfoViewController.h
//  FuXin
//
//  Created by SumFlower on 14-5-26.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FXMyInfoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *userImage;//用户头像
@property (weak, nonatomic) IBOutlet UITextField *userNiChen;//用户昵称
@property (weak, nonatomic) IBOutlet UILabel *industryCertification;//行业认证
@property (weak, nonatomic) IBOutlet UILabel *courseCategory;//开课类别
@property (weak, nonatomic) IBOutlet UILabel *telephone;//手机号码
@property (weak, nonatomic) IBOutlet UILabel *email;//邮箱
@property (weak, nonatomic) IBOutlet UILabel *birthday;//生日
@property (weak, nonatomic) IBOutlet UILabel *sex;//性别
- (IBAction)changeHeaderAction:(id)sender;

@end
