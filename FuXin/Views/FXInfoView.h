//
//  FXInfoView.h
//  FuXin
//
//  Created by 徐宝桥 on 14-6-17.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FXInfoView : UIView

@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@property (nonatomic, strong) UILabel *infoLabel;

- (void)setText:(NSString *)text;

- (void)show;
- (void)hide;

@end
