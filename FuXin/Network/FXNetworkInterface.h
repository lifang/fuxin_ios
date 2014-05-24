//
//  FXNetworkInterface.h
//  FuXin
//
//  Created by 徐宝桥 on 14-5-23.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#define kRequestURL   @"url"
#define kRequestType  @"type"
#define kRequestParm  @"parm"

//Authentication
/*
    info:登入
    type:POST
    pram:authenticationRequest
 */
static NSString *AuthenticationIn = @"https://mobileim.mock.fuwu.com/api/Authentication";
/*
    info:登出
    type:PUT
    parm:unAuthenticationRequest
 */
static NSString *AuthenticationOut = @"https://mobileim.mock.fuwu.com/api/Authentication";

//Password
/*
    info:修改密码
    type:PUT
    parm:changePasswordRequest
 */
static NSString *ChangePassword = @"https://mobileim.mock.fuwu.com/api/Password";

//Contact
/*
    info:获取联系人列表
    type:POST
    parm:contactRequest
 */
static NSString *GetContactList = @"https://mobileim.mock.fuwu.com/api/Contact";
/*
    info:屏蔽联系人
    type:PUT
    parm:blockContactRequest
 */
static NSString *BlockContact = @"https://mobileim.mock.fuwu.com/api/Contact";

//Message
/*
    info:获取聊天消息
    type:POST
    parm:messageRequest
 */
static NSString *GetMessage = @"https://mobileim.mock.fuwu.com/api/Message";
/*
    info:发送聊天消息
    type:PUT
    parm:sendMessageRequest
 */
static NSString *SendMessage = @"https://mobileim.mock.fuwu.com/api/Message";

//Profile
/*
    info:获取个人信息
    type:POST
    parm:profileRequest
 */
static NSString *GetProfile = @"https://mobileim.mock.fuwu.com/api/Profile";

//ContactDetail
/*
    info:获取单个联系人详细信息
    type:POST
    parm:contactDetailRequest
         id
 */
static NSString *GetContactDetail = @"https://mobileim.mock.fuwu.com/api/ContactDetail/{id}";
/*
    info:修改联系人备注
    type:PUT
    parm:changeContactDetailRequest
 */
static NSString *ModifyContactDetail = @"https://mobileim.mock.fuwu.com/api/ContactDetail";

//Register
/*
    info:注册
    type:POST
    parm:registerRequest
 */
static NSString *Regist = @"https://mobileim.mock.fuwu.com/api/Register";

//ValidateCode
/*
    info:验证码
    type:POST
    parm:validatecodeRequest
 */
static NSString *Validate = @"https://mobileim.mock.fuwu.com/ValidateCode";




//获取接口url、请求方式及参数信息
NSDictionary* dictionaryForAuthenticationIn() {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            AuthenticationIn,kRequestURL,
            @"POST",kRequestType,
            @"authenticationRequest",kRequestParm,
            nil];
}

NSDictionary* dictionaryForAuthenticationOut() {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            AuthenticationOut,kRequestURL,
            @"PUT",kRequestType,
            @"sendMessageRequest",kRequestParm,
            nil];
}

NSDictionary* dictionaryForChangePassword() {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            ChangePassword,kRequestURL
            @"PUT",kRequestType,
            @"changePasswordRequest",kRequestParm,
            nil];
}

NSDictionary* dictionaryForGetContactList() {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            GetContactList,kRequestURL
            @"POST",kRequestType,
            @"contactRequest",kRequestParm,
            nil];
}

NSDictionary* dictionaryForBlockContact() {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            BlockContact,kRequestURL,
            @"PUT",kRequestType,
            @"blockContactRequest",kRequestParm,
            nil];
}

NSDictionary* dictionaryForGetMessage() {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            GetMessage,kRequestURL,
            @"POST",kRequestType,
            @"messageRequest",kRequestParm,
            nil];
}

NSDictionary* dictionaryForSendMessage() {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            SendMessage,kRequestURL
            @"PUT",kRequestType,
            @"sendMessageRequest",kRequestParm,
            nil];
}

NSDictionary* dictionaryForGetProfile() {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            GetProfile,kRequestURL,
            @"POST",kRequestType,
            @"profileRequest",kRequestParm,
            nil];
}

NSDictionary* dictionaryForGetContactDetail() {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            GetContactDetail,kRequestURL,
            @"POST",kRequestType,
            @"contactDetailRequest",kRequestParm,
            nil];
}

NSDictionary* dictionaryForModifyContactDetail() {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            ModifyContactDetail,kRequestURL
            @"PUT",kRequestType,
            @"changeContactDetailRequest",kRequestParm,
            nil];
}

NSDictionary* dictionaryForRegist() {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            Regist,kRequestURL,
            @"POST",kRequestType,
            @"registerRequest",kRequestParm,
            nil];
}

NSDictionary* dictionaryForValidate() {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            Validate,kRequestURL,
            @"POST",kRequestType,
            @"validatecodeRequest",kRequestParm,
            nil];
}



