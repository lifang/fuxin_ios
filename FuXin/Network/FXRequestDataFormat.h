//
//  FXRequestDataFormat.h
//  FuXin
//
//  Created by 徐宝桥 on 14-5-24.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXHttpRequest.h"

@interface FXRequestDataFormat : NSObject

/*
 登入
 username:用户名
 password:密码
 result:返回结果
 */
+ (void)authenticationInWithUsername:(NSString *)username
                            Password:(NSString *)password
                            Finished:(Result)result;

/*
 登出
 token: 成功登入返回的令牌
 userID:成功登入返回的userID
 result:返回结果
 */
+ (void)authenticationOutWithToken:(NSString *)token
                            UserID:(int32_t)userID
                          Finished:(Result)result;

/*
 修改密码
 token: 成功登入返回的令牌
 userID:成功登入返回的userID
 original:原密码
 password:新密码
 comfirm:重复新密码
 result:返回结果
 */
+ (void)changePasswordWithToken:(NSString *)token
                         UserID:(int32_t)userID
               OriginalPassword:(NSString *)original
                       Password:(NSString *)password
                PasswordConfirm:(NSString *)confirm
                   ValidateCode:(NSString *)validate
                       Finished:(Result)result;

/*
 获取联系人
 token: 成功登入返回的令牌
 userID:成功登入返回的userID
 timeStamp:时间戳
 result:返回结果
 */
+ (void)getContactListWithToken:(NSString *)token
                         UserId:(int32_t)userID
                      TimeStamp:(NSString *)timeStamp
                       Finished:(Result)result;

/*
 屏蔽联系人
 token: 成功登入返回的令牌
 userID:成功登入返回的userID
 contactID:屏蔽联系人的ID
 isBlocked:屏蔽、取消屏蔽
 result:返回结果
 */
+ (void)blockContactWithToken:(NSString *)token
                       UserID:(int32_t)userID
                    ContactID:(int32_t)contactID
                    IsBlocked:(BOOL)isBlocked
                     Finished:(Result)result;

/*
 发送消息
 token: 成功登入返回的令牌
 userID:成功登入返回的userID
 message:消息
 result:返回结果
 */
+ (void)sendMessageWithToken:(NSString *)token
                      UserID:(int32_t)userID
                     Message:(Message *)message
                    Finished:(Result)result;
/*
 接收消息
 token: 成功登入返回的令牌
 userID:成功登入返回的userID
 timeStamp:时间戳
 result:返回结果
 */
+ (void)getMessageWithToken:(NSString *)token
                     UserID:(int32_t)userID
                  TimeStamp:(NSString *)timeStamp
                   Finished:(Result)result;

/*
 获取个人信息
 token: 成功登入返回的令牌
 userID:成功登入返回的userID
 result:返回结果
 */
+ (void)getProfileWithToken:(NSString *)token
                     UserID:(int32_t)userID
                   Finished:(Result)result;

/*
 获取联系人详情
 token: 成功登入返回的令牌
 userID:成功登入返回的userID
 contactID:联系人ID
 result:返回结果
 */
+ (void)getContactDetailWithToken:(NSString *)token
                           UserID:(int32_t)userID
                        ContactID:(int32_t)contactID
                         Finished:(Result)result;

/*
 修改联系人备注
 token: 成功登入返回的令牌
 userID:成功登入返回的userID
 contact:联系人对象
 result:返回结果
 */
+ (void)modifyContactDetailWithToken:(NSString *)token
                              UserID:(int32_t)userID
                             Contact:(Contact *)contact
                            Finished:(Result)result;

/*
 注册
 phoneNumber:手机号
 name:用户名
 password:密码
 passwordConfirm:密码
 validataCode:验证码
 result:返回结果
 */
+ (void)registerWithPhoneNumber:(NSString *)phoneNumber
                           Name:(NSString *)name
                       Password:(NSString *)password
                PasswordConfirm:(NSString *)passwordConfirm
                   ValidateCode:(NSString *)validateCode
                       Finished:(Result)result;

/*
 验证码
 phoneNumber:手机号
 type:类型
 result:返回结果
 */
+ (void)validateCodeWithPhoneNumber:(NSString *)phoneNumber
                               Type:(ValidateCodeRequest_ValidateType)type
                           Finished:(Result)result;

@end
