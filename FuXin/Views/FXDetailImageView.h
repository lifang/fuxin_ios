//
//  FXDetailImageView.h
//  FuXin
//
//  Created by 徐宝桥 on 14-6-10.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVCircularProgressView.h"

@interface FXDetailImageView : UIView

@property (nonatomic, strong) UIImageView *bigImageView;

@property (nonatomic, strong) EVCircularProgressView *progressView;

- (void)setBigImageWithData:(NSData *)data;

@end
