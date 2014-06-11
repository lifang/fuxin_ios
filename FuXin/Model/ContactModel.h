//
//  ContactModel.h
//  FuXin
//
//  Created by lihongliang on 14-5-19.
//  Copyright (c) 2014年 comdosoft. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum{
    ContactIdentityGuest = 0,   //福客
    ContactIdentityTeacher = 1 //福师
} ContactIdentity;  //身份

typedef enum{
    ContactRelationshipOrderFrom = 1,
    ContactRelationshipOrderTo = 2,
    ContactRelationshipSubScribeFrom = 4,
    ContactRelationshipSubScribeTo = 8,
    ContactRelationshipBuyer ,  //订购者
    ContactRelationshipFans ,  //关注着
    ContactRelationshipNone   //聊天者(无关系)
} ContactRelationship;  //关系

typedef enum{
    ContactSexMale = 0,
    ContactSexFemale,
    ContactSexSecret,
} ContactSex; //性别

/*
 *联系人
 */
@interface ContactModel : NSObject
///联系人ID
@property (strong, nonatomic) NSString *contactID;
///昵称
@property (strong, nonatomic) NSString *contactNickname;
///头像
@property (strong, nonatomic) NSData *contactAvatar;
///头像URL
@property (strong, nonatomic) NSString *contactAvatarURL;
///性别
@property (assign, nonatomic) ContactSex contactSex;
///身份 (福师, 福客)
@property (assign, nonatomic) ContactIdentity contactIdentity;
///关系 (订购者/聊天者/关注者)
@property (assign, nonatomic) ContactRelationship contactRelationship;
///备注
@property (strong, nonatomic) NSString *contactRemark;
///拼音 (未知)
@property (strong, nonatomic) NSString *contactPinyin;
///屏蔽
@property (assign, nonatomic) BOOL contactIsBlocked;
///最后对话时间
@property (strong, nonatomic) NSString *contactLastContactTime;
///未知
@property (assign, nonatomic) BOOL contactIsProvider;
///认证
@property (strong, nonatomic) NSString *contactLisence;
///课程类别
@property (strong, nonatomic) NSString *contactPublishClassType;
///个性签名
@property (strong, nonatomic) NSString *contactSignature;
///生日
@property (strong, nonatomic) NSString *contactBirthday;
///手机
@property (strong, nonatomic) NSString *contactTelephone;
///邮箱
@property (strong, nonatomic) NSString *contactEmail;

@end
