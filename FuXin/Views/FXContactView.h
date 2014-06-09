//
//  FXContactView.h
//  FuXin
//
//  Created by 徐宝桥 on 14-5-29.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactModel.h"

@interface FXContactView : UIView<UITextFieldDelegate>

@property (nonatomic, strong) ContactModel *contact;

@property (nonatomic, strong) UIView *deskView;

@property (nonatomic, strong) UIImageView *photoView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UIImageView *sexView;

@property (nonatomic, strong) UILabel *remarkLabel;

@property (nonatomic, strong) UITextField *remarkField;

@property (nonatomic, strong) UIImageView *relationView1;

@property (nonatomic, strong) UIImageView *relationView2;

- (void)hiddenContactView;

@end
