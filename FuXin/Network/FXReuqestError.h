//
//  FXReuqestError.h
//  FuXin
//
//  Created by 徐宝桥 on 14-7-10.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FXReuqestError : NSObject<UIAlertViewDelegate>

@property (nonatomic, strong) UIAlertView *alert;

//账号顶掉处理
- (void)requestDidFailWithErrorCode:(int)errorType;

@end
