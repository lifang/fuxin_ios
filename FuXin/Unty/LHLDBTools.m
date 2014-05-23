//
//  LHLDBTools.m
//  FuXin
//
//  Created by lihongliang on 14-5-14.
//  Copyright (c) 2014年 comdosoft. All rights reserved.
//

#import "LHLDBTools.h"
#define kNUMBER_OF_CHAT_PER_LOAD 20 //每次加载的聊天记录条数
#define kDATE_FORMAT @"YYYY-MM-dd hh:mm:ss:SSS"  //时间格式 ,主要用于判断聊天记录的顺序
#define kDB_NAME @"FuXinDB.sqlite" //数据库文件名
#import "SharedClass.h"

static LHLDBTools *staticDBTools;

@interface LHLDBTools()
@property (nonatomic,strong) NSString *userID; //数据库对应的userID
@end

@implementation LHLDBTools

///根据公用单例中的userID返回数据库操作单例.
+ (instancetype)shareLHLDBTools{
    static LHLDBTools *dbTool = nil;
    if ([SharedClass sharedObject].userID == nil) {
        return nil;
    }
    if (!dbTool || ![dbTool.userID isEqualToString:[SharedClass sharedObject].userID]) {  //如果无对象,或者对象userID不同 ,则创建对象
        NSFileManager *manager = [NSFileManager defaultManager];
        BOOL isDirectory;
        if (![manager fileExistsAtPath:kUSER_FOLDER_PATH isDirectory:&isDirectory]){
            NSError *error;
            [manager createDirectoryAtPath:kUSER_FOLDER_PATH withIntermediateDirectories:YES attributes:nil error:&error];
        }
        dbTool = [[LHLDBTools alloc] init];
        NSString *dbPath = [kUSER_FOLDER_PATH stringByAppendingPathComponent:kDB_NAME];
        [dbTool setPath:dbPath];
        [dbTool setQueue:[FMDatabaseQueue databaseQueueWithPath:dbPath]];
        dbTool.userID = [SharedClass sharedObject].userID;
        [dbTool createBaseTables];
        
        NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
        [formatter setDateFormat:kDATE_FORMAT];
        [dbTool setFormatter:formatter];
    }
    return dbTool;
}

- (void)setPath:(NSString*)path{
    _databasePath = path;
}

- (void)setQueue:(FMDatabaseQueue*)databaseQueue{
    _databaseQueue = databaseQueue;
}

- (void)setFormatter:(NSDateFormatter *)formatter{
    _dateFormatter = formatter;
}

//TODO:创建初始的基本表  : ID字段全部使用INTEGER类型
- (void)createBaseTables{
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        BOOL everythingIsOK = YES;
        
        //2.创建聊天记录表
        /*
         联系人ID
         发送时间
         内容(文本及表情)
         附件
         状态(已发送 / 已读 /未发送 /未读)
         
         创建以子增长主键为依据的索引
         */
        FMResultSet *rs = [db executeQuery:@"SELECT name FROM SQLITE_MASTER WHERE name = 'ChattingRecords'"];
        if (![rs next]) {
            [rs close];
            everythingIsOK = everythingIsOK ? [db executeUpdate:@"CREATE TABLE ChattingRecords (id INTEGER PRIMARY KEY AUTOINCREMENT , contactID INTEGER , time TEXT , content TEXT ,attachment TEXT , status NUMBERIC)"] : NO;
            //因本数据库插入数据压力较小,应多用索引提升查询效率
            [db beginTransaction];
            everythingIsOK = everythingIsOK ? [db executeUpdate:@"CREATE INDEX chatting_id_index ON ChattingRecords(id DESC)"] : NO; //id索引用于统计总数
            everythingIsOK = everythingIsOK ? [db executeUpdate:@"CREATE INDEX chatting_status_index ON ChattingRecords(status)"] : NO; //status索引用于统计未读聊天记录数
            everythingIsOK = everythingIsOK ? [db executeUpdate:@"CREATE INDEX chatting_contactID_index ON ChattingRecords(contactID)"] : NO; //contactID索引用于分页加载聊天记录
            if (!everythingIsOK) {
                [db rollback];
            }
            [db commit];
            
        }
        
        [rs close];
        
        //3.创建联系人表
        /*
         联系人ID,
         昵称,
         头像,
         性别,
         身份,
         关系,
         备注
         */
        rs = [db executeQuery:@"SELECT name FROM SQLITE_MASTER WHERE name = 'Contacts'"];
        if (![rs next]) {
            [rs close];
            everythingIsOK = everythingIsOK ? [db executeUpdate:@"CREATE TABLE Contacts (id INTEGER PRIMARY KEY ,contactID INTEGER ,nickname TEXT,avatar TEXT ,sex NUMBERIC ,identity NUMBERIC ,relationship NUMBERIC , remark TEXT)"] : NO;
        }
        
        [rs close];
        
        //4.创建最近对话表
        /*
         联系人ID ,
         最后对话时间
         */
        rs = [db executeQuery:@"SELECT name FROM SQLITE_MASTER WHERE name = 'Conversations'"];
        if (![rs next]) {
            [rs close];
            everythingIsOK = everythingIsOK ? [db executeUpdate:@"CREATE TABLE Conversations (id INTEGER PRIMARY KEY ,contactID INTEGER , lastCommunicateTime TEXT)"] : NO;
        }
        [rs close];
        if (!everythingIsOK) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"数据库创建出错" message:@"数据库创建出错" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            });
        }
    }];
}

#pragma mark 联系人
///查找所有联系人
+ (void)getAllContactsWithFinished:(void (^)(NSArray *, NSString *))finished{
    [[LHLDBTools shareLHLDBTools].databaseQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray *allContactsArray = [NSMutableArray array];
        FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM Contacts"];
        while ([resultSet next]) {
            ContactModel *contact = [LHLDBTools convertToContactModelFromResultSet:resultSet];
            [allContactsArray addObject:contact];
        }
        [resultSet close];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (finished) {
                finished(allContactsArray,nil);
            }
        });
    }];
    [[LHLDBTools shareLHLDBTools].databaseQueue close];
}

///转换resultSet为联系人模型
+ (ContactModel *)convertToContactModelFromResultSet:(FMResultSet *)resultSet{
    ContactModel *obj = [[ContactModel alloc] init];
    obj.contactID = [NSString stringWithFormat:@"%d",[resultSet intForColumn:@"contactID"]];
    obj.contactNickname = [NSString stringWithFormat:@"%@",[resultSet stringForColumn:@"nickname"]];
    obj.contactIdentity = [resultSet boolForColumn:@"identity"] ? ContactIdentityTeacher : ContactIdentityGuest;
    obj.contactAvatar = [NSString stringWithFormat:@"%@",[resultSet stringForColumn:@"avatar"]];
    obj.contactRemark = [NSString stringWithFormat:@"%@",[resultSet stringForColumn:@"remark"]];
    obj.contactSex = [resultSet boolForColumn:@"sex"] ? ContactSexFemale : ContactSexMale;
    int relationshipValue = [resultSet intForColumn:@"relationship"];
    switch (relationshipValue) {
        case 1:
            obj.contactRelationship = ContactRelationshipBuyer;
            break;
        case 2:
            obj.contactRelationship = ContactRelationshipFans;
            break;
        case 3:
            obj.contactRelationship = ContactRelationshipNone;
            break;
        default:
            break;
    }
    return obj;
}

///根据联系人ID查找联系人
+ (void)findContactWithContactID:(NSString *)contactID withFinished:(void (^)(ContactModel *contact,NSString *errorMessage))finished{
    if (!contactID) {
        if (finished) {
            finished(nil,@"必须指定ID!");
        }
        return;
    }
    [[LHLDBTools shareLHLDBTools].databaseQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM Contacts WHERE contactID = ?",[NSNumber numberWithInt:contactID.intValue]];
        if ([resultSet next]) {
            ContactModel *contact = [LHLDBTools convertToContactModelFromResultSet:resultSet];
            [resultSet close];
            if (finished) {
                finished(contact,nil);
            }
            return;
        }
        if (finished) {
            finished(nil,@"没有该联系人记录");
        }
    }];
}
///保存联系人 (自动判断插入/更新)
+ (void)saveContact:(ContactModel *)contactObj withFinished:(void (^)(BOOL))finished{
    if (!contactObj) {
        if (finished) {
            finished(NO);
        }
    }
    [[LHLDBTools shareLHLDBTools].databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL transationSucceeded;
        FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM Contacts WHERE contactID = ?",[NSNumber numberWithInt:contactObj.contactID.intValue]];
        if ([resultSet next]) { //查询到已存在联系人 ,则update
            transationSucceeded = [db executeUpdate:@"UPDATE Contacts SET ,nickname = ? ,avatar = ? ,sex = ? ,identity = ? ,relationship = ? ,remark = ? WHERE contactID = ?"
                                   ,contactObj.contactNickname
                                   ,contactObj.contactAvatar
                                   ,[NSNumber numberWithInt:contactObj.contactSex ]
                                   ,[NSNumber numberWithInt:contactObj.contactIdentity]
                                   ,[NSNumber numberWithInt:contactObj.contactRelationship]
                                   ,contactObj.contactRemark
                                   ,contactObj.contactID];
        }else{  //不存在联系人,则 insert
            transationSucceeded = [db executeUpdate:@"INSERT INTO Contacts (contactID ,nickname ,avatar ,sex ,identity ,relationship ,remark) VALUES (? ,? ,? ,? ,? ,? ,?)"
                                   ,contactObj.contactID
                                   ,contactObj.contactNickname
                                   ,contactObj.contactAvatar
                                   ,[NSNumber numberWithInt:contactObj.contactSex ]
                                   ,[NSNumber numberWithInt:contactObj.contactIdentity]
                                   ,[NSNumber numberWithInt:contactObj.contactRelationship]
                                   ,contactObj.contactRemark];
        }
        if (!transationSucceeded){
            *rollback = YES;
            if (finished) {
                finished(NO);
            }
        }else{
            if (finished) {
                finished(YES);
            }
        }
        
    }];
}

#pragma mark 最近对话
///保存最近对话信息
+ (void)saveConversation:(ConversationModel *)conversation withFinished:(void (^)(BOOL flag))finished{
    if (!conversation) {
        if (finished) {
            finished(NO);
        }
        return;
    }
    //查找是否存在
    [[LHLDBTools shareLHLDBTools].databaseQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *resultSet = [db executeQuery:@""];
        if ([resultSet next]) { //存在 ,更新日期即可
            [resultSet close];
            [[LHLDBTools shareLHLDBTools].databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
                BOOL transactionSucceeded = [db executeUpdate:@"UPDATE Conversations SET lastCommunicateTime = ? WHERE contactID = ?",
                                             conversation.conversationLastCommunicateTime,
                                             conversation.conversationContactID.intValue];
                if (transactionSucceeded) {
                    if (finished) {
                        finished(YES);
                    }
                }else{
                    *rollback = YES;
                    if (finished) {
                        finished(NO);
                    }
                }
            }];
        }else{
            [[LHLDBTools shareLHLDBTools].databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
                BOOL transactionSucceeded = [db executeUpdate:@"INSERT INTO Conversations (contactID ,lastCommunicateTime) VALUES (? ,?)"
                                             ,conversation.conversationContactID.intValue
                                             ,conversation.conversationLastCommunicateTime];
                if (transactionSucceeded) {
                    if (finished) {
                        finished(YES);
                    }
                }else{
                    *rollback = YES;
                    if (finished) {
                        finished(NO);
                    }
                }
            }];
        }
    }];
}

///查找所有最近对话信息
+ (void)getConversationsWithFinished:(void (^)(NSMutableArray *conversationsArray,NSString *errorMessage))finished{
    [[LHLDBTools shareLHLDBTools].databaseQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray *conversations = [NSMutableArray array];
        FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM Conversations"];
        while ([resultSet next]) {
            ConversationModel *conversation = [LHLDBTools convertToConversationFromResultSet:resultSet];
            [conversations addObject:conversation];
        }
        [resultSet close];
        if (finished) {
            finished(conversations,nil);
        }
    }];
}

///转换resultSet为最近对话对象
+ (ConversationModel *)convertToConversationFromResultSet:(FMResultSet *)resultSet{
    ConversationModel *obj = [[ConversationModel alloc] init];
    obj.conversationContactID = [NSString stringWithFormat:@"%d",[resultSet intForColumn:@"contactID"]];
    obj.conversationLastCommunicateTime = [resultSet stringForColumn:@"lastCommunicateTime"];
    return obj;
}

///删除最近对话信息
+ (void)deleteConversationWithID:(NSString *)contactID withFinished:(void (^)(BOOL))finished{
    if (!contactID) {
        if (finished) {
            finished(NO);
        }
        return;
    }
    [[LHLDBTools shareLHLDBTools].databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL executeSucceeded;
        executeSucceeded = [db executeUpdate:@"DELETE FROM Conversations WHERE contactID = ?",contactID.intValue];
        if (executeSucceeded) {
            if (finished) {
                finished(YES);
            }
        }else{
            *rollback = YES;
            if (finished){
                finished(NO);
            }
        }
    }];
}

#pragma mark 聊天记录
///保存一条聊天记录
+ (void)saveChattingRecord:(MessageModel *)chattingRecord withFinished:(void (^)(BOOL flag))finished{
    if (!chattingRecord) {
        if (finished) {
            finished(NO);
        }
        return;
    }
    //聊天记录不用update
    [[LHLDBTools shareLHLDBTools].databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL executeSucceeded;
        executeSucceeded = [db executeUpdate:@"INSERT INTO ChattingRecords (contactID ,time ,content ,attachment ,status) VALUES (? ,? ,? ,? ,?)"
                            ,chattingRecord.messageRecieverID.intValue
                            ,chattingRecord.messageSendTime
                            ,chattingRecord.messageContent
                            ,chattingRecord.messageAttachment
                            ,chattingRecord.messageStatus
                            ];
        if (finished) {
            finished(executeSucceeded);
        }
        if (!executeSucceeded) {
            *rollback = YES;
        }
    }];
}

///查询与某个联系人的最后N条聊天记录
+ (void)getLatestChattingRecordsWithContactID:(NSString *)contactID withFinished:(void (^)(NSArray *recordsArray,NSString *errorMessage))finished{
    if (!contactID || contactID.length < 1) {
        if (finished) {
            finished(nil,@"不正确的联系人ID");
        }
        return;
    }
    [[LHLDBTools shareLHLDBTools].databaseQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray *records = [NSMutableArray array];
        FMResultSet *rst = [db executeQuery:@"SELECT * FROM ChattingRecords WHERE contactID = ? ORDER BY id LIMIT ?",contactID.intValue,kNUMBER_OF_CHAT_PER_LOAD];
        while ([rst next]) {
            MessageModel *message = [LHLDBTools convertToMessageFromResultSet:rst];
            [records addObject:message];
        }
        [rst close];
        if (records.count > 0) {
            if (finished) {
                finished([NSArray arrayWithArray:records],nil);
            }
        }else{
            if (finished) {
                finished(nil,@"未查找到记录");
            }
        }
    }];
}

///按index查询之前若干条聊天记录
+ (void)getChattingRecordsWithContactID:(NSString *)contactID beforeIndex:(NSInteger)index withFinished:(void (^)(NSArray *recordsArray,NSString *errorMessage))finished{
    if (!contactID || contactID.length < 1) {
        if (finished) {
            finished(nil,@"2不正确的联系人ID");
        }
        return;
    }
    [[LHLDBTools shareLHLDBTools].databaseQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray *records = [NSMutableArray array];
        FMResultSet *rst = [db executeQuery:@"SELECT * FROM ChattingRecords WHERE contactID = ? ORDER BY id LIMIT ? OFFSET ?",contactID.intValue ,kNUMBER_OF_CHAT_PER_LOAD ,index];
        while ([rst next]) {
            MessageModel *message = [LHLDBTools convertToMessageFromResultSet:rst];
            [records addObject:message];
        }
        [rst close];
        if (records.count > 0) {
            if (finished) {
                finished([NSArray arrayWithArray:records],nil);
            }
        }else{
            if (finished) {
                finished(nil,@"未查找到记录");
            }
        }
    }];
}

///查询某个时间点之前的N条聊天记录
+ (void)getChattingRecordsBeforeTime:(NSString *)timeString WithContactID:(NSString *)contactID withFinished:(void (^)(NSArray *recordsArray,NSString *errorMessage))finished{
    //暂时弃用
}

///查询某联系人未读信息的数量
+ (void)numberOfUnreadChattingRecordsWithContactID:(NSString *)contactID withFinished:(void (^)(NSInteger quantity,NSString *errorMessage))finished{
    if (!contactID || contactID.length < 1) {
        if (finished) {
            finished(0,@"3不正确的联系人ID");
        }
        return;
    }
    [[LHLDBTools shareLHLDBTools].databaseQueue inDatabase:^(FMDatabase *db) {
        NSInteger quantity = 0;
        //3表示status的未读状态
        FMResultSet *rst = [db executeQuery:@"SELECT COUNT(id) quantity FROM ChattingRecords WHERE contactID = ? AND status = 3",contactID.intValue ,kNUMBER_OF_CHAT_PER_LOAD ,index];
        while ([rst next]) {
            quantity = [rst intForColumn:@"quantity"];
        }
        [rst close];
        if (finished) {
            finished(quantity ,nil);
        }
    }];
}

///清除某联系人的未读状态
+ (void)clearUnreadStatusWithContactID:(NSString *)contactID withFinished:(void (^)(BOOL flag))finished{
    if (!contactID || contactID.length < 1) {
        if (finished) {
            finished(NO);
            return;
        }
    }
    [[LHLDBTools shareLHLDBTools].databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL executeSucceeded;
        executeSucceeded = [db executeUpdate:@"UPDATE ChattingRecords SET status = 4 WHERE status = 3 AND contactID = ?",contactID.intValue];
        if (executeSucceeded) {
            if (finished) {
                finished(YES);
            }
        }else{ //操作未完成
            *rollback = YES;
            if (finished) {
                finished(NO);
            }
        }
    }];
}

///删除某个联系人的聊天记录
+ (void)deleteChattingRecordsWithContactID:(NSString *)contactID withFinished:(void (^)(BOOL flag))finished{
    if (!contactID || contactID.length < 1) {
        if (finished) {
            finished(NO);
        }
    }
    [[LHLDBTools shareLHLDBTools].databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL executeSucceeded;
        executeSucceeded = [db executeUpdate:@"DELETE FROM ChattingRecords WHERE contactID = ?",contactID.intValue];
        if (executeSucceeded) {
            if (finished) {
                finished(YES);
            }
        }else{
            *rollback = YES;
            if (finished) {
                finished(NO);
            }
        }
    }];
}

///把result转换成message
+ (MessageModel *)convertToMessageFromResultSet:(FMResultSet *)resultSet{
    MessageModel *message = [[MessageModel alloc] init];
    message.messageRecieverID = [NSString stringWithFormat:@"%d",[resultSet intForColumn:@"contactID"]];
    message.messageSendTime = [NSString stringWithString:[resultSet stringForColumn:@"time"]];
    message.messageContent = [NSString stringWithString:[resultSet stringForColumn:@"content"]];
    message.messageAttachment = [NSString stringWithString:[resultSet stringForColumn:@"attachment"]];
    message.messageStatus = (MessageStatus)[resultSet intForColumn:@"status"];
    return message;
}

#pragma mark 其他方法
//TODO:比较两个日期字符串的早晚  ,1 :同时 , 2 :前面的更早 ,3 :后面的更早 , 负数:参数/格式错误
+ (short int)compareDateFormat:(NSString *)format1 withAnotherDateFormat:(NSString *)format2{
    if (!format1 || !format2) {
        return -1;
    }
    NSDate *date1 = [[LHLDBTools shareLHLDBTools].dateFormatter dateFromString:format1];
    NSDate *date2 = [[LHLDBTools shareLHLDBTools].dateFormatter dateFromString:format2];
    switch ([date1 compare:date2]) {
        case NSOrderedSame:
            return 1;
            break;
        case NSOrderedAscending:
            return 2;
            break;
        case NSOrderedDescending:
            return 3;
            break;
        default:
            return -2;
            break;
    }
}
@end
