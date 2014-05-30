//
//  FXNetworkInterface.h
//  FuXin
//
//  Created by 徐宝桥 on 14-5-23.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#define kRequestURL       @"url"
#define kRequestType      @"type"
#define kRequestPostData  @"postdata"

//Authentication
/*
 info:登入
 type:POST
 pram:authenticationRequest
 */
static NSString *AuthenticationIn = @"https://118.242.18.189/IMApiMock/api/Authentication";
/*
 info:登出
 type:PUT
 parm:unAuthenticationRequest
 */
static NSString *AuthenticationOut = @"https://118.242.18.189/IMApiMock/api/Authentication";

//Password
/*
 info:修改密码
 type:PUT
 parm:changePasswordRequest
 */
static NSString *ChangePassword = @"https://118.242.18.189/IMApiMock/api/Password";

//Contact
/*
 info:获取联系人列表
 type:POST
 parm:contactRequest
 */
static NSString *GetContactList = @"https://118.242.18.189/IMApiMock/api/Contact";
/*
 info:屏蔽联系人
 type:PUT
 parm:blockContactRequest
 */
static NSString *BlockContact = @"https://118.242.18.189/IMApiMock/api/Contact";

//Message
/*
 info:获取聊天消息
 type:POST
 parm:messageRequest
 */
static NSString *GetMessage = @"https://118.242.18.189/IMApiMock/api/Message";
/*
 info:发送聊天消息
 type:PUT
 parm:sendMessageRequest
 */
static NSString *SendMessage = @"https://118.242.18.189/IMApiMock/api/Message";

//Profile
/*
 info:获取个人信息
 type:POST
 parm:profileRequest
 */
static NSString *GetProfile = @"https://118.242.18.189/IMApiMock/api/Profile";

//ContactDetail
/*
 info:获取单个联系人详细信息
 type:POST
 parm:contactDetailRequest
 id
 */
static NSString *GetContactDetail = @"https://118.242.18.189/IMApiMock/api/ContactDetail/{id}";
/*
 info:修改联系人备注
 type:PUT
 parm:changeContactDetailRequest
 */
static NSString *ModifyContactDetail = @"https://118.242.18.189/IMApiMock/api/ContactDetail";

//Register
/*
 info:注册
 type:POST
 parm:registerRequest
 */
static NSString *Regist = @"https://118.242.18.189/IMApiMock/api/Register/";

//ValidateCode
/*
 info:验证码
 type:POST
 parm:validatecodeRequest
 */
static NSString *Validate = @"https://118.242.18.189/IMApiMock/api/ValidateCode";


@interface FXNetworkInterface : NSObject

//字典中的kRequestPostData仅用于占位，之后会替换成需要post的内容
NSMutableDictionary* dictionaryForAuthenticationIn();    //登入
NSMutableDictionary* dictionaryForAuthenticationOut();   //登出
NSMutableDictionary* dictionaryForChangePassword();      //修改密码
NSMutableDictionary* dictionaryForGetContactList();      //获取联系人列表
NSMutableDictionary* dictionaryForBlockContact();        //屏蔽联系人
NSMutableDictionary* dictionaryForGetMessage();          //接收消息
NSMutableDictionary* dictionaryForSendMessage();         //发送消息
NSMutableDictionary* dictionaryForGetProfile();          //获取个人信息
NSMutableDictionary* dictionaryForGetContactDetail();    //获取某一联系人详情
NSMutableDictionary* dictionaryForModifyContactDetail(); //修改联系人备注
NSMutableDictionary* dictionaryForRegist();              //注册
NSMutableDictionary* dictionaryForValidate();            //验证码

@end
