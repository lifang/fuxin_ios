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
    ContactRelationshipBuyer = 1,  //订购者
    ContactRelationshipFans = 2,  //关注着
    ContactRelationshipNone = 3  //聊天者(无关系)
} ContactRelationship;  //关系

typedef enum{
    ContactSexMale = 0,
    ContactSexFemale = 1
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
@property (strong, nonatomic) NSString *contactAvatar;
///性别
@property (assign, nonatomic) ContactSex contactSex;
///身份 (福师, 福客)
@property (assign, nonatomic) ContactIdentity contactIdentity;
///关系 (订购者/聊天者/关注者)
@property (assign, nonatomic) ContactRelationship contactRelationship;
///备注
@property (strong, nonatomic) NSString *contactRemark;
@end
