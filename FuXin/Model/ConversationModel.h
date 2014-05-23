//
//  ConversationModel.h
//  FuXin
//
//  Created by lihongliang on 14-5-21.
//  Copyright (c) 2014年 comdosoft. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
  最近对话
  一个对象对应对话界面的一个聊天对话
 */
@interface ConversationModel : NSObject
///对话联系人ID
@property (strong ,nonatomic)NSString *conversationContactID;
///最后对话时间
@property (strong ,nonatomic)NSString *conversationLastCommunicateTime;
@end
