//
//  FXNetworkInterface.m
//  FuXin
//
//  Created by 徐宝桥 on 14-5-23.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXNetworkInterface.h"

@implementation FXNetworkInterface

//获取接口url、请求方式
NSMutableDictionary* dictionaryForAuthenticationIn() {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            AuthenticationIn,kRequestURL,
            @"POST",kRequestType,
            @"authenticationRequest",kRequestPostData,
            nil];
}

NSMutableDictionary* dictionaryForAuthenticationOut() {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            AuthenticationOut,kRequestURL,
            @"PUT",kRequestType,
            @"sendMessageRequest",kRequestPostData,
            nil];
}

NSMutableDictionary* dictionaryForChangePassword() {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            ChangePassword,kRequestURL,
            @"PUT",kRequestType,
            @"changePasswordRequest",kRequestPostData,
            nil];
}

NSMutableDictionary* dictionaryForResetPassword() {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            ResetPassword,kRequestURL,
            @"PUT",kRequestType,
            @"resetPasswordRequest",kRequestPostData,
            nil];
}

NSMutableDictionary* dictionaryForGetContactList() {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            GetContactList,kRequestURL,
            @"POST",kRequestType,
            @"contactRequest",kRequestPostData,
            nil];
}

NSMutableDictionary* dictionaryForBlockContact() {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            BlockContact,kRequestURL,
            @"PUT",kRequestType,
            @"blockContactRequest",kRequestPostData,
            nil];
}

NSMutableDictionary* dictionaryForGetMessage() {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            GetMessage,kRequestURL,
            @"POST",kRequestType,
            @"messageRequest",kRequestPostData,
            nil];
}

NSMutableDictionary* dictionaryForSendMessage() {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            SendMessage,kRequestURL,
            @"PUT",kRequestType,
            @"sendMessageRequest",kRequestPostData,
            nil];
}

NSMutableDictionary* dictionaryForGetProfile() {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            GetProfile,kRequestURL,
            @"POST",kRequestType,
            @"profileRequest",kRequestPostData,
            nil];
}

NSMutableDictionary* dictionaryForModifyProfile() {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            ModifyProfile,kRequestURL,
            @"PUT",kRequestType,
            @"profileRequest",kRequestPostData,
            nil];
}

NSMutableDictionary* dictionaryForGetContactDetail() {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            GetContactDetail,kRequestURL,
            @"POST",kRequestType,
            @"contactDetailRequest",kRequestPostData,
            nil];
}

NSMutableDictionary* dictionaryForModifyContactDetail() {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            ModifyContactDetail,kRequestURL,
            @"PUT",kRequestType,
            @"changeContactDetailRequest",kRequestPostData,
            nil];
}

NSMutableDictionary* dictionaryForRegist() {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            Regist,kRequestURL,
            @"POST",kRequestType,
            @"registerRequest",kRequestPostData,
            nil];
}

NSMutableDictionary* dictionaryForValidate() {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            Validate,kRequestURL,
            @"POST",kRequestType,
            @"validatecodeRequest",kRequestPostData,
            nil];
}

NSMutableDictionary* dictionaryForClient() {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            ClientPush, kRequestURL,
            @"PUT", kRequestType,
            @"clientInfo",kRequestPostData,
            nil];
}

NSMutableDictionary* dictionaryForMessageConfirm() {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            MessageConfirm,kRequestURL,
            @"POST",kRequestType,
            @"confirm",kRequestPostData,
            nil];
}

@end
