//
//  FXRequestDataFormat.m
//  FuXin
//
//  Created by 徐宝桥 on 14-5-24.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXRequestDataFormat.h"

@implementation FXRequestDataFormat

+ (void)authenticationInWithUsername:(NSString *)username
                            Password:(NSString *)password
                            Finished:(Result)result{
    AuthenticationRequest *PBObject = [[[[AuthenticationRequest builder]
                                         setUserName:username]
                                        setPassword:password] build];
    NSData *PBData = [PBObject data];
    //获取登录的请求信息
    NSMutableDictionary *requestInfo = dictionaryForAuthenticationIn();
    //修改postdata内容
    [requestInfo setObject:PBData forKey:kRequestPostData];
    //发送请求
    [FXHttpRequest setHttpRequestWithInfo:requestInfo responseResult:^(BOOL success,NSData *response){
        result(success,response);
    }];
}

+ (void)authenticationOutWithToken:(NSString *)token
                            UserID:(int32_t)userID
                          Finished:(Result)result {
    UnAuthenticationRequest *PBObject = [[[[UnAuthenticationRequest builder]
                                           setToken:token]
                                          setUserId:userID] build];
    NSData *PBData = [PBObject data];
    //获取登出的请求信息
    NSMutableDictionary *requestInfo = dictionaryForAuthenticationOut();
    //修改postdata内容
    [requestInfo setObject:PBData forKey:kRequestPostData];
    //发送请求
    [FXHttpRequest setHttpRequestWithInfo:requestInfo responseResult:^(BOOL success,NSData *response){
        result(success,response);
    }];
}

+ (void)changePasswordWithToken:(NSString *)token
                         UserID:(int32_t)userID
                   ValidateCode:(NSString *)validateCode
               OriginalPassword:(NSString *)original
                       Password:(NSString *)password
                PasswordConfirm:(NSString *)confirm
                       Finished:(Result)result {
    ChangePasswordRequest *PBObject = [[[[[[[[ChangePasswordRequest builder]
                                             setToken:token]
                                            setUserId:userID]
                                           setValidateCode:validateCode]
                                          setOriginalPassword:original]
                                         setPassword:password]
                                        setPasswordConfirm:confirm] build];
    NSData *PBData = [PBObject data];
    //获取修改密码请求信息
    NSMutableDictionary *requestInfo = dictionaryForChangePassword();
    //修改postdata内容
    [requestInfo setObject:PBData forKey:kRequestPostData];
    //发送请求
    [FXHttpRequest setHttpRequestWithInfo:requestInfo responseResult:^(BOOL success,NSData *response){
        result(success,response);
    }];
}

+ (void)resetPasswordWithPhoneNumber:(NSString *)phoneNumber
                        ValidateCode:(NSString *)validateCode
                            Password:(NSString *)password
                     PasswordConfirm:(NSString *)passwordConfirm
                            Finished:(Result)result {
    ResetPasswordRequest *PBObject = [[[[[[ResetPasswordRequest builder]
                                          setPhoneNumber:phoneNumber]
                                         setValidateCode:validateCode]
                                        setPassword:password]
                                       setPasswordConfirm:passwordConfirm] build];
    NSData *PBData = [PBObject data];
    //获取重置密码请求信息
    NSMutableDictionary *requestInfo = dictionaryForResetPassword();
    //修改postdata内容
    [requestInfo setObject:PBData forKey:kRequestPostData];
    //发送请求
    [FXHttpRequest setHttpRequestWithInfo:requestInfo responseResult:^(BOOL success,NSData *response){
        result(success,response);
    }];
}

+ (void)getContactListWithToken:(NSString *)token
                         UserId:(int32_t)userID
                      TimeStamp:(NSString *)timeStamp
                       Finished:(Result)result {
    ContactRequest *PBObject = [[[[[ContactRequest builder]
                                  setToken:token]
                                 setUserId:userID]
                                 setTimeStamp:timeStamp ] build];
    NSData *PBData = [PBObject data];
    //获取联系人列表请求内容
    NSMutableDictionary *requestInfo = dictionaryForGetContactList();
    //修改postdata内容
    [requestInfo setObject:PBData forKey:kRequestPostData];
    //发送请求
    [FXHttpRequest setHttpRequestWithInfo:requestInfo responseResult:^(BOOL success,NSData *response){
        result(success,response);
    }];
}

+ (void)blockContactWithToken:(NSString *)token
                       UserID:(int32_t)userID
                    ContactID:(int32_t)contactID
                    IsBlocked:(BOOL)isBlocked
                     Finished:(Result)result {
    BlockContactRequest *PBObject = [[[[[[BlockContactRequest builder]
                                         setToken:token]
                                        setUserId:userID]
                                       setContactId:contactID]
                                      setIsBlocked:isBlocked] build];
    NSData *PBData = [PBObject data];
    //获取屏蔽请求内容
    NSMutableDictionary *requestInfo = dictionaryForBlockContact();
    //修改postdata内容
    [requestInfo setObject:PBData forKey:kRequestPostData];
    //发送请求
    [FXHttpRequest setHttpRequestWithInfo:requestInfo responseResult:^(BOOL success,NSData *response){
        result(success,response);
    }];
}

+ (void)sendMessageWithToken:(NSString *)token
                      UserID:(int32_t)userID
                     Message:(Message *)message
                    Finished:(Result)result {
    SendMessageRequest *PBObject = [[[[[SendMessageRequest builder]
                                       setToken:token]
                                      setUserId:userID]
                                     setMessage:message] build];
    NSData *PBData = [PBObject data];
    //获取发送信息请求内容
    NSMutableDictionary *requestInfo = dictionaryForSendMessage();
    //修改postdata内容
    [requestInfo setObject:PBData forKey:kRequestPostData];
    //发送请求
    [FXHttpRequest setHttpRequestWithInfo:requestInfo responseResult:^(BOOL success,NSData *response){
        result(success,response);
    }];
}

+ (void)getMessageWithToken:(NSString *)token
                     UserID:(int32_t)userID
                  TimeStamp:(NSString *)timeStamp
                   Finished:(Result)result {
    MessageRequest *PBObject = [[[[[MessageRequest builder]
                                   setToken:token]
                                  setUserId:userID]
                                 setTimeStamp:timeStamp] build];
    NSData *PBData = [PBObject data];
    //获取接收信息请求内容
    NSMutableDictionary *requestInfo = dictionaryForGetMessage();
    //修改postdata内容
    [requestInfo setObject:PBData forKey:kRequestPostData];
    //发送请求
    [FXHttpRequest setHttpRequestWithInfo:requestInfo responseResult:^(BOOL success,NSData *response){
        result(success,response);
    }];
}

+ (void)getProfileWithToken:(NSString *)token
                     UserID:(int32_t)userID
                   Finished:(Result)result {
    ProfileRequest *PBObject = [[[[ProfileRequest builder]
                                  setToken:token]
                                 setUserId:userID] build];
    NSData *PBData = [PBObject data];
    //请求信息
    NSMutableDictionary *requestInfo = dictionaryForGetProfile();
    //修改postdata内容
    [requestInfo setObject:PBData forKey:kRequestPostData];
    //发送请求
    [FXHttpRequest setHttpRequestWithInfo:requestInfo responseResult:^(BOOL success,NSData *response){
        result(success,response);
    }];
}

+ (void)changeProfileWithToken:(NSString *)token
                        UserID:(int32_t)userID
                     Signature:(NSString *)signature
                         Tiles:(NSData *)tiles
                   ContentType:(NSString *)contentType
                      NickName:(NSString *)nickName
                      Finished:(Result)result {
    ChangeProfileRequest *PBObject;
    if (!nickName) {
        PBObject = [[[[[[[ChangeProfileRequest builder]
                          setToken:token]
                         setUserId:userID]
                        setSignature:signature]
                       setTiles:tiles]
                      setContentType:contentType] build];
    }
    else if (!tiles) {
        PBObject = [[[[[[ChangeProfileRequest builder]
                          setToken:token]
                         setUserId:userID]
                        setSignature:signature]
                     setNickName:nickName] build];
    }
    else {
        PBObject = [[[[[[[[ChangeProfileRequest builder]
                          setToken:token]
                         setUserId:userID]
                        setSignature:signature]
                       setTiles:tiles]
                      setContentType:contentType]
                     setNickName:nickName] build];
    }
    NSData *PBData = [PBObject data];
    //请求信息
    NSMutableDictionary *requestInfo = dictionaryForModifyProfile();
    //修改postdata内容
    [requestInfo setObject:PBData forKey:kRequestPostData];
    //发送请求
    [FXHttpRequest setHttpRequestWithInfo:requestInfo responseResult:^(BOOL success, NSData *response) {
        result(success, response);
    }];
}

+ (void)getContactDetailWithToken:(NSString *)token
                           UserID:(int32_t)userID
                        ContactID:(int32_t)contactID
                         Finished:(Result)result {
    ContactDetailRequest *PBObject = [[[[[ContactDetailRequest builder]
                                         setToken:token] setUserId:userID]
                                       setContactId:contactID] build];
    NSData *PBData = [PBObject data];
    //请求信息
    NSMutableDictionary *requestInfo = dictionaryForGetContactDetail();
    //修改postdata
    NSString *urlPrefix = [requestInfo objectForKey:kRequestURL];
    NSString *url = [urlPrefix stringByAppendingString:[NSString stringWithFormat:@"{%d}",contactID]];
    [requestInfo setObject:url forKey:url];
    [requestInfo setObject:PBData forKey:kRequestPostData];
    //发送请求
    [FXHttpRequest setHttpRequestWithInfo:requestInfo responseResult:^(BOOL success,NSData *response){
        result(success,response);
    }];
}

+ (void)modifyContactDetailWithToken:(NSString *)token
                              UserID:(int32_t)userID
                             Contact:(Contact *)contact
                            Finished:(Result)result {
    ChangeContactDetailRequest *PBObject = [[[[[ChangeContactDetailRequest builder] setToken:token] setUserId:userID] setContact:contact] build];
    NSData *PBData = [PBObject data];
    //请求信息
    NSMutableDictionary *requestInfo = dictionaryForModifyContactDetail();
    //修改postdata
    [requestInfo setObject:PBData forKey:kRequestPostData];
    //发送请求
    [FXHttpRequest setHttpRequestWithInfo:requestInfo responseResult:^(BOOL success,NSData *response){
        result(success,response);
    }];
}

+ (void)registerWithPhoneNumber:(NSString *)phoneNumber
                       Password:(NSString *)password 
                PasswordConfirm:(NSString *)passwordConfirm
                   ValidateCode:(NSString *)validateCode
                       Finished:(Result)result {
    RegisterRequest *PBObject = [[[[[[RegisterRequest builder]
                                      setMobilePhoneNumber:phoneNumber]
                                    setPassword:password]
                                   setPasswordConfirm:passwordConfirm]
                                  setValidateCode:validateCode] build];
    NSData *PBData = [PBObject data];
    //请求信息
    NSMutableDictionary *requestInfo = dictionaryForRegist();
    //修改postdata
    [requestInfo setObject:PBData forKey:kRequestPostData];
    //发送请求
    [FXHttpRequest setHttpRequestWithInfo:requestInfo responseResult:^(BOOL success,NSData *response){
        result(success,response);
    }];
}

+ (void)validateCodeWithPhoneNumber:(NSString *)phoneNumber
                               Type:(ValidateCodeRequest_ValidateType)type
                           Finished:(Result)result {
    ValidateCodeRequest *PBObject = [[[[ValidateCodeRequest builder]
                                      setPhoneNumber:phoneNumber]
                                      setType:type] build];
    NSData *PBData = [PBObject data];
    //请求信息
    NSMutableDictionary *requestInfo = dictionaryForValidate();
    //修改postdata
    [requestInfo setObject:PBData forKey:kRequestPostData];
    //发送请求
    [FXHttpRequest setHttpRequestWithInfo:requestInfo responseResult:^(BOOL success,NSData *response){
        result(success,response);
    }];
}

+ (void)clientInfoWithToken:(NSString *)token
                     UserID:(int32_t)userID
                     Client:(ClientInfo *)clientInfo
                   Finished:(Result)result {
    ClientInfoRequest *PBObject = [[[[[ClientInfoRequest builder] setToken:token] setUserId:userID] setClientInfo:clientInfo] build];
    NSData *PBData = [PBObject data];
    //请求信息
    NSMutableDictionary *requestInfo = dictionaryForClient();
    //修改postdata
    [requestInfo setObject:PBData forKey:kRequestPostData];
    //发送请求
    [FXHttpRequest setHttpRequestWithInfo:requestInfo responseResult:^(BOOL success, NSData *response) {
        result(success, response);
    }];
}

+ (void)messageConfirmedWithToken:(NSString *)token
                           UserID:(int32_t)userID
                        ContactID:(int32_t)contactID
                        TimeStamp:(NSString *)timeStamp
                         Finished:(Result)result {
    MessageConfirmedRequest *PBObject = [[[[[[MessageConfirmedRequest builder] setUserId:userID] setToken:token] setContactId:contactID] setTimeStamp:timeStamp] build];
    NSData *PBData = [PBObject data];
    //请求信息
    NSMutableDictionary *requestInfo = dictionaryForMessageConfirm();
    //修改postdata
    [requestInfo setObject:PBData forKey:kRequestPostData];
    //发送请求
    [FXHttpRequest setHttpRequestWithInfo:requestInfo responseResult:^(BOOL success, NSData *response) {
        result(success, response);
    }];
}

+ (void)messageHistoryWithToken:(NSString *)token
                         UserID:(int32_t)userID
                      ContactID:(int32_t)contactID
                      PageIndex:(int32_t)pageIndex
                       PageSize:(int32_t)pageSize
                       Finished:(Result)result {
    MessageHistoryRequest *PBObject = [[[[[[[MessageHistoryRequest builder] setToken:token] setUserId:userID] setContactId:contactID] setPageIndex:pageIndex] setPageSize:pageSize] build];
    NSData *PBData = [PBObject data];
    //请求信息
    NSMutableDictionary *requestInfo = dictionaryForMessageHistory();
    //修改postdata
    [requestInfo setObject:PBData forKey:kRequestPostData];
    //发送请求
    [FXHttpRequest setHttpRequestWithInfo:requestInfo responseResult:^(BOOL success, NSData *response) {
        result(success, response);
    }];
}

@end
