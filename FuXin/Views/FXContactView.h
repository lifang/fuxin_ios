//
//  FXContactView.h
//  FuXin
//
//  Created by 徐宝桥 on 14-5-29.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FXContactView : UIView<UITextFieldDelegate>

@property (nonatomic, strong) UIView *deskView;

@property (nonatomic, strong) UIImageView *photoView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UIImageView *sexView;

@property (nonatomic, strong) UILabel *remarkLabel;

@property (nonatomic, strong) UITextField *remarkField;

@end
