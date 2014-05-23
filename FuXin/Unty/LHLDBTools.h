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
///保存联系人
+ (void)saveContact:(ContactModel *)contactObj withFinished:(void (^)(BOOL flag))finished;

#pragma mark 最近对话
///保存最近对话信息
+ (void)saveConversation:(ConversationModel *)conversation withFinished:(void (^)(BOOL flag))finished;
///查找所有最近对话信息
+ (void)getConversationsWithFinished:(void (^)(NSMutableArray *conversationsArray,NSString *errorMessage))finished;
///删除最近对话信息
+ (void)deleteConversationWithID:(NSString *)contactID withFinished:(void (^)(BOOL flag))finished;

#pragma mark 聊天记录
///保存一条聊天记录
+ (void)saveChattingRecord:(MessageModel *)chattingRecord withFinished:(void (^)(BOOL flag))finished;
///查询与某个联系人的最后N条聊天记录
+ (void)getLatestChattingRecordsWithContactID:(NSString *)contactID withFinished:(void (^)(NSArray *recordsArray,NSString *errorMessage))finished;
///按index查询之前若干条聊天记录
+ (void)getChattingRecordsWithContactID:(NSString *)contactID beforeIndex:(NSInteger)index withFinished:(void (^)(NSArray *recordsArray,NSString *errorMessage))finished;
///查询某个时间点之前的N条聊天记录
+ (void)getChattingRecordsBeforeTime:(NSString *)timeString WithContactID:(NSString *)contactID withFinished:(void (^)(NSArray *recordsArray,NSString *errorMessage))finished;
///查询某联系人未读信息的数量
+ (void)numberOfUnreadChattingRecordsWithContactID:(NSString *)contactID withFinished:(void (^)(NSInteger quantity,NSString *errorMessage))finished;
///清除某联系人的未读状态
+ (void)clearUnreadStatusWithContactID:(NSString *)contactID withFinished:(void (^)(BOOL flag))finished;
///删除某个联系人的聊天记录
+ (void)deleteChattingRecordsWithContactID:(NSString *)contactID withFinished:(void (^)(BOOL flag))finished;

@end
