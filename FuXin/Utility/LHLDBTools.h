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

#pragma mark 用户
///根据ID查询用户
+ (id)findUserWithUserID:(NSString *)userID;
///保存用户
+ (void)saveUser:(id)user;

#pragma mark 联系人
///根据用户ID查找其联系人
+ (NSArray *)getContactsWithUserID:(NSString *)userID;
///根据联系人ID查找联系人
+ (id)findContactWithContactID:(NSString *)contactID;
///保存联系人  with: 用户ID  联系人信息
+ (void)saveContact:(id)contact;

#pragma mark 最近对话
///保存最近对话信息
///查找所有最近对话信息
///删除最近对话信息

#pragma mark 聊天记录
///保存一条聊天记录
+ (void)saveChattingRecord:(id)chattingRecord;
///查询与某个联系人的最后N条聊天记录
+ (NSArray *)getLatestChattingRecordsForUserID:(NSString *)userID withContactID:(NSString *)contactID;
///查询某个时间点之前的N条聊天记录
+ (NSArray *)getChattingRecordsBeforeTime:(NSString *)timeString forUserID:(NSString *)userID withContactID:(NSString *)contactID;
///查询某联系人未读信息的数量
+ (NSInteger)numberOfUnreadChattingRecordsForUserID:(NSString *)userID withContactID:(NSString *)contactID;
///清除某联系人的未读状态
+ (void)clearUnreadStatusForUserID:(NSString *)userID withContactID:(NSString *)contactID;
///删除某个联系人的聊天记录
+ (void)deleteChattingRecordsForUserID:(NSString *)userID withContactID:(NSString *)contactID;
@end
