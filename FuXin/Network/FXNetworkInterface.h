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

//https://118.242.18.189
//https://i.fuwu.com

//Authentication
/*
 info:登入
 type:POST
 pram:authenticationRequest
 */
static NSString *AuthenticationIn = @"https://i.fuwu.com/IMApi/api/Authentication";

/*
 info:登出
 type:PUT
 parm:unAuthenticationRequest
 */
static NSString *AuthenticationOut = @"https://i.fuwu.com/IMApi/api/Authentication";

//Password
/*
 info:修改密码
 type:PUT
 parm:changePasswordRequest
 */
static NSString *ChangePassword = @"https://i.fuwu.com/IMApi/api/ChangePassword";

/*
 info:重置密码
 type:PUT
 parm:resetPasswordRequest
 */
static NSString *ResetPassword = @"https://i.fuwu.com/IMApi/api/ResetPassword";

//Contact
/*
 info:获取联系人列表
 type:POST
 parm:contactRequest
 */
static NSString *GetContactList = @"https://i.fuwu.com/IMApi/api/Contact";
/*
 info:屏蔽联系人
 type:PUT
 parm:blockContactRequest
 */
static NSString *BlockContact = @"https://i.fuwu.com/IMApi/api/Contact";

//Message
/*
 info:获取聊天消息
 type:POST
 parm:messageRequest
 */
static NSString *GetMessage = @"https://i.fuwu.com/IMApi/api/Message";
/*
 info:发送聊天消息
 type:PUT
 parm:sendMessageRequest
 */
static NSString *SendMessage = @"https://i.fuwu.com/IMApi/api/Message";

//Profile
/*
 info:获取个人信息
 type:POST
 parm:profileRequest
 */
static NSString *GetProfile = @"https://i.fuwu.com/IMApi/api/Profile";
/*
 info:获取个人信息
 type:PUT
 parm:profileRequest
 */
static NSString *ModifyProfile = @"https://i.fuwu.com/IMApi/api/Profile";

//ContactDetail
/*
 info:获取单个联系人详细信息
 type:POST
 parm:contactDetailRequest
 id
 */
static NSString *GetContactDetail = @"https://i.fuwu.com/IMApi/api/ContactDetail/";
/*
 info:修改联系人备注
 type:PUT
 parm:changeContactDetailRequest
 */
static NSString *ModifyContactDetail = @"https://i.fuwu.com/IMApi/api/ContactDetail";

//Register
/*
 info:注册
 type:POST
 parm:registerRequest
 */
static NSString *Regist = @"https://i.fuwu.com/IMApi/api/Register/";

//ValidateCode
/*
 info:验证码
 type:POST
 parm:validatecodeRequest
 */
static NSString *Validate = @"https://i.fuwu.com/IMApi/api/ValidateCode";


/*
// info:推送相关
// type:PUT
// parm:
 */
static NSString *ClientPush = @"https://i.fuwu.com/IMApi/api/Client";

/*
 info:确认接收消息
 type:POST
 */
static NSString *MessageConfirm = @"https://i.fuwu.com/IMApi/api/MessageConfirmed";

@interface FXNetworkInterface : NSObject

//字典中的kRequestPostData仅用于占位，之后会替换成需要post的内容
NSMutableDictionary* dictionaryForAuthenticationIn();    //登入
NSMutableDictionary* dictionaryForAuthenticationOut();   //登出
NSMutableDictionary* dictionaryForChangePassword();      //修改密码
NSMutableDictionary* dictionaryForResetPassword();       //重置密码
NSMutableDictionary* dictionaryForGetContactList();      //获取联系人列表
NSMutableDictionary* dictionaryForBlockContact();        //屏蔽联系人
NSMutableDictionary* dictionaryForGetMessage();          //接收消息
NSMutableDictionary* dictionaryForSendMessage();         //发送消息
NSMutableDictionary* dictionaryForGetProfile();          //获取个人信息
NSMutableDictionary* dictionaryForModifyProfile();       //修改个人消息
NSMutableDictionary* dictionaryForGetContactDetail();    //获取某一联系人详情
NSMutableDictionary* dictionaryForModifyContactDetail(); //修改联系人备注
NSMutableDictionary* dictionaryForRegist();              //注册
NSMutableDictionary* dictionaryForValidate();            //验证码
NSMutableDictionary* dictionaryForClient();              //推送绑定
NSMutableDictionary* dictionaryForMessageConfirm();      //确认接收消息

@end
