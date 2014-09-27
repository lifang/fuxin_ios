//
//  FXReuqestError.m
//  FuXin
//
//  Created by 徐宝桥 on 14-7-10.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXReuqestError.h"
#import "SharedClass.h"
#import "FXAppDelegate.h"

@implementation FXReuqestError

- (void)requestDidFailWithErrorCode:(int)errorType {
    if (errorType == 2001) {
        FXAppDelegate *delegate = [FXAppDelegate shareFXAppDelegate];
        if (!delegate.isShowRelogin) {
            delegate.isShowRelogin = YES;
            if (!_alert) {
                self.alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                    message:@"您的账号已在别处登录，请重新登录！"
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
            }
            [_alert show];
            [[delegate shareRootViewContorller] releaseResource];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.cancelButtonIndex) {
        FXAppDelegate *delegate = [FXAppDelegate shareFXAppDelegate];
        delegate.isShowRelogin = NO;
        delegate.token = nil;
        delegate.userID = -1;
        delegate.user = nil;
        //数据库操作保存id
        [SharedClass sharedObject].userID = nil;
        [[delegate shareRootViewContorller] showLoginViewController];
        [[delegate shareRootViewContorller] removeMainController];
    }
}

@end
