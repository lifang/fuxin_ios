//
//  ContactModel.h
//  FuXin
//
//  Created by lihongliang on 14-5-19.
//  Copyright (c) 2014年 comdosoft. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum{
    ContactIdentityGuest,   //福客
    ContactIdentityTeacher  //福师
} ContactIdentity;  //身份

typedef enum{
    ContactRelationshipBuyer,  //订购者
    ContactRelationshipFans,  //关注着
    ContactRelationshipNone   //聊天者(无关系)
} ContactRelationship;  //关系

@interface ContactModel : NSObject
///联系人ID
@property (strong, nonatomic) NSString *contactID;
///昵称
@property (strong, nonatomic) NSString *nickname;
///头像
@property (strong, nonatomic) NSString *avatar;
///性别
@property (assign, nonatomic) NSString *sex;
///身份 (福师, 福客)
@property (assign, nonatomic) ContactIdentity identity;
///关系 (订购者/聊天者/关注者)
@property (assign, nonatomic) ContactRelationship relationship;
///备注
@property (strong, nonatomic) NSString *remark;
@end
