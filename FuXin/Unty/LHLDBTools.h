//
//  LHLDBTools.h
//  FuXin
//
//  Created by lihongliang on 14-5-14.
//  Copyright (c) 2014年 comdosoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "ContactModel.h"
#import "MessageModel.h"
#import "ConversationModel.h"



/** LHLDBTools
 *
 * 在单例,线程安全下使用数据库
 * 支持多线程调用
 * 本类中所有数据库操作方法都由flag或errorMsg返回操作状态
 */
@interface LHLDBTools : NSObject
///数据库路径
@property (nonatomic,strong,readonly) NSString *databasePath;

///数据库操作单例
@property (nonatomic,strong,readonly) FMDatabaseQueue *databaseQueue;

///DateFormatter
@property (nonatomic,strong,readonly) NSDateFormatter *dateFormatter;

///返回本类的单例
+ (instancetype)shareLHLDBTools;

#pragma mark 用户   (暂时弃用)
///根据ID查询用户
//+ (id)findUserWithUserID:(NSString *)userID;
///保存用户
//+ (void)saveUser:(id)user;

#pragma mark 联系人
///查找所有联系人
+ (void)getAllContactsWithFinished:(void (^)(NSArray *contactsArray,NSString *errorMessage))finished;

///根据联系人ID查找联系人
+ (void)findContactWithContactID:(NSString *)contactID withFinished:(void (^)(ContactModel *contact,NSString *errorMessage))finished;

///保存联系人(自动判断插入/更新)
+ (void)saveContact:(NSArray *)contactArray withFinished:(void (^)(BOOL flag))finished;

///删除联系人
+ (void)deleteContact:(NSArray *)contactArray withFinished:(void (^)(BOOL flag))finished;

#pragma mark 最近对话
///保存最近对话信息 (自动判断插入/更新)
+ (void)saveConversation:(NSArray *)conversationArray withFinished:(void (^)(BOOL flag))finished;

///查找所有最近对话信息
+ (void)getConversationsWithFinished:(void (^)(NSMutableArray *conversationsArray,NSString *errorMessage))finished;

///删除最近对话信息
+ (void)deleteConversationWithID:(NSString *)contactID withFinished:(void (^)(BOOL flag))finished;

///删除所有最近对话
+ (void)deleteAllConversationsWithFinished:(void (^)(BOOL flag))finished;

#pragma mark 聊天记录
///保存聊天记录
+ (void)saveChattingRecord:(NSArray *)chattingRecordArray withFinished:(void (^)(BOOL flag))finished;

///查询与某个联系人的最后N条聊天记录  (目前按时间顺序排列)
+ (void)getLatestChattingRecordsWithContactID:(NSString *)contactID withFinished:(void (^)(NSArray *recordsArray,NSString *errorMessage))finished;

///按index查询之前若干条聊天记录   (目前按时间顺序排列) (使用: index为已有数据数组的count ,直接add在数组后面即可)
+ (void)getChattingRecordsWithContactID:(NSString *)contactID beforeIndex:(NSInteger)index withFinished:(void (^)(NSArray *recordsArray,NSString *errorMessage))finished;

///查询某个时间点之前的N条聊天记录 (暂时弃用)
+ (void)getChattingRecordsBeforeTime:(NSString *)timeString WithContactID:(NSString *)contactID withFinished:(void (^)(NSArray *recordsArray,NSString *errorMessage))finished;

///查询某联系人未读信息的数量
+ (void)numberOfUnreadChattingRecordsWithContactID:(NSString *)contactID withFinished:(void (^)(NSInteger quantity,NSString *errorMessage))finished;

///查询某联系人所有未读消息
+ (void)getUnreadChattingRecordsWithContactID:(NSString *)contactID withFinished:(void (^)(NSArray *recordsArray ,NSString *errorMessage))finished;

///清除某联系人的未读状态
+ (void)clearUnreadStatusWithContactID:(NSString *)contactID withFinished:(void (^)(BOOL flag))finished;

///删除某个联系人的聊天记录
+ (void)deleteChattingRecordsWithContactID:(NSString *)contactID withFinished:(void (^)(BOOL flag))finished;

///删除本用户所有聊天记录
+ (void)deleteAllChattingRecordWithFinished:(void (^)(BOOL flag))finished;
@end
