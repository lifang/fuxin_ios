//
//  MessageModel.h
//  FuXin
//
//  Created by lihongliang on 14-5-15.
//  Copyright (c) 2014年 comdosoft. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum{
    MessageStatusDidSent = 1,  //已发送成功
    MessageStatusUnSent,   //未发送
    MessageStatusUnRead,   //未读消息
    MessageStatusDidRead   //已读
} MessageStatus;  //消息状态

/**
 一条消息 ,  聊天的最小数据单元
 发送者和接收者ID决定消息的发送/接收方向
 */
@interface MessageModel : NSObject
///联系人ID
@property (nonatomic, strong) NSString *messageRecieverID;
///发送时间
@property (nonatomic, strong) NSString *messageSendTime;
///内容
@property (nonatomic, strong) NSString *messageContent;
///附件()
@property (nonatomic, strong) NSString *messageAttachment;
///状态
@property (nonatomic, assign) MessageStatus messageStatus;
//是否显示时间
@property (nonatomic, strong) NSNumber *messageShowTime;
@end
