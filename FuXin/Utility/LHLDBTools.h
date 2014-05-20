//
//  LHLDBTools.h
//  FuXin
//
//  Created by lihongliang on 14-5-14.
//  Copyright (c) 2014年 comdosoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"




/** LHLDBTools
 *
 * 在单例,线程安全下使用数据库
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
+ (NSArray *)getAllContacts;
///根据联系人ID查找联系人
+ (id)findContactWithContactID:(NSString *)contactID;
///保存联系人
+ (void)saveContact:(id)contact;

#pragma mark 最近对话
///保存最近对话信息
+ (void)saveConversation:(id)conversation;
///查找所有最近对话信息
+ (NSMutableArray *)getConversations;
///删除最近对话信息
+ (void)deleteConversation;

#pragma mark 聊天记录
///保存一条聊天记录
+ (void)saveChattingRecord:(id)chattingRecord;
///查询与某个联系人的最后N条聊天记录
+ (NSArray *)getLatestChattingRecordsWithContactID:(NSString *)contactID;
///按index查询之前若干条聊天记录
+ (NSArray *)getChattingRecordsWithQuantity:(NSInteger)quantity beforeIndex:(NSInteger)index;
///查询某个时间点之前的N条聊天记录
+ (NSArray *)getChattingRecordsBeforeTime:(NSString *)timeString WithContactID:(NSString *)contactID;
///查询某联系人未读信息的数量
+ (NSInteger)numberOfUnreadChattingRecordsWithContactID:(NSString *)contactID;
///清除某联系人的未读状态
+ (void)clearUnreadStatusWithContactID:(NSString *)contactID;
///删除某个联系人的聊天记录
+ (void)deleteChattingRecordsWithContactID:(NSString *)contactID;
@end
