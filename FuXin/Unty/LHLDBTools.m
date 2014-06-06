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

static LHLDBTools *staticDBTools;

@interface LHLDBTools()
@property (assign, nonatomic) int32_t userID; //数据库对应的userID
@end

@implementation LHLDBTools

///根据公用单例中的userID返回数据库操作单例.
+ (instancetype)shareLHLDBTools{
    static LHLDBTools *dbTool = nil;
    if ([FXAppDelegate shareFXAppDelegate].userID == 0) {  //userID必须赋值 ,数据库才有效
        return nil;
    }
    if (!dbTool || !(dbTool.userID == [FXAppDelegate shareFXAppDelegate].userID)) {  //如果无对象,或者对象userID不同 ,则创建对象
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
        dbTool.userID = [FXAppDelegate shareFXAppDelegate].userID;
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
            everythingIsOK = everythingIsOK ? [db executeUpdate:@"CREATE TABLE ChattingRecords (id INTEGER PRIMARY KEY AUTOINCREMENT ,contactID INTEGER , time TEXT , content TEXT ,attachment TEXT , showTime NUMBERIC, status NUMBERIC)"] : NO;
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
            //联系人ID
            //昵称
            //头像
            //性别
            //身份 (福师, 福客)
            //关系 (订购者/聊天者/关注者)
            //备注
            //拼音 (未知)
            //屏蔽
            //最后对话时间
            //未知
            //认证
            //课程类别
            //个性签名
            //生日
            //手机
            //邮箱
            everythingIsOK = everythingIsOK ? [db executeUpdate:@"CREATE TABLE Contacts (contactID INTEGER PRIMARY KEY NOT NULL,nickname TEXT,avatar BLOB ,avatarURL TEXT ,sex NUMBERIC ,identity NUMBERIC ,relationship NUMBERIC , remark TEXT ,pinyin TEXT ,isBlocked NUMBERIC ,lastContactTime TEXT ,isProvider NUMBERIC ,lisence TEXT ,publishClassType TEXT ,signature TEXT ,birthday TEXT ,telephone TEXT ,email TEXT)"] : NO;
            [db beginTransaction];
            everythingIsOK = everythingIsOK ? [db executeUpdate:@"CREATE INDEX contacts_contactID_index ON Contacts(contactID)"] : NO; //contactID索引
            if (!everythingIsOK) {
                [db rollback];
            }
            [db commit];
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
            everythingIsOK = everythingIsOK ? [db executeUpdate:@"CREATE TABLE Conversations (contactID INTEGER PRIMARY KEY NOT NULL, lastCommunicateTime TEXT, lastChat TEXT)"] : NO;
            [db beginTransaction];
            everythingIsOK = everythingIsOK ? [db executeUpdate:@"CREATE INDEX conversations_contactID_index ON Conversations(contactID)"] : NO; //索引
            if (!everythingIsOK) {
                [db rollback];
            }
            [db commit];
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
    NSMutableArray *allContactsArray = [NSMutableArray array];
    [[LHLDBTools shareLHLDBTools].databaseQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM Contacts"];
        while ([resultSet next]) {
            ContactModel *contact = [LHLDBTools convertToContactModelFromResultSet:resultSet];
            [allContactsArray addObject:contact];
        }
        [resultSet close];
    }];
    if (finished) {
        finished(allContactsArray,nil);
    }
}

///转换resultSet为联系人模型
+ (ContactModel *)convertToContactModelFromResultSet:(FMResultSet *)resultSet{
    ContactModel *obj = [[ContactModel alloc] init];
    obj.contactID = [NSString stringWithFormat:@"%d",[resultSet intForColumn:@"contactID"]];
    obj.contactNickname = [resultSet stringForColumn:@"nickname"];
    obj.contactIdentity = [resultSet boolForColumn:@"identity"] ? ContactIdentityTeacher : ContactIdentityGuest;
    obj.contactAvatar = [NSData dataWithData:[resultSet dataForColumn:@"avatar"]];
    obj.contactAvatarURL = [resultSet stringForColumn:@"avatarURL"];
    obj.contactRemark = [resultSet stringForColumn:@"remark"];
    obj.contactSex = [resultSet boolForColumn:@"sex"] ? ContactSexFemale : ContactSexMale;
//    int relationshipValue = [resultSet intForColumn:@"relationship"];
//    switch (relationshipValue) {
//        case 1:
//            obj.contactRelationship = ContactRelationshipBuyer;
//            break;
//        case 2:
//            obj.contactRelationship = ContactRelationshipFans;
//            break;
//        case 3:
//            obj.contactRelationship = ContactRelationshipNone;
//            break;
//        default:
//            break;
//    }
    obj.contactRelationship = (ContactRelationship)[resultSet intForColumn:@"relationship"];
    obj.contactPinyin = [resultSet stringForColumn:@"pinyin"];
    obj.contactIsBlocked = [resultSet boolForColumn:@"isBlocked"];
    obj.contactLastContactTime = [resultSet stringForColumn:@"lastContactTime"];
    obj.contactIsProvider = [resultSet boolForColumn:@"isProvider"];
    obj.contactLisence = [resultSet stringForColumn:@"lisence"];
    obj.contactPublishClassType = [resultSet stringForColumn:@"publishClassType"];
    obj.contactSignature = [resultSet stringForColumn:@"signature"];
    obj.contactBirthday = [resultSet stringForColumn:@"birthday"];
    obj.contactTelephone = [resultSet stringForColumn:@"telephone"];
    obj.contactEmail = [resultSet stringForColumn:@"email"];
    
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
    __block ContactModel *contact;
    [[LHLDBTools shareLHLDBTools].databaseQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM Contacts WHERE contactID = ?",[NSNumber numberWithInt:contactID.intValue]];
        if ([resultSet next]) {
            contact = [LHLDBTools convertToContactModelFromResultSet:resultSet];
            [resultSet close];
        }
    }];
    if (finished) {
        if (contact == nil) {
            finished(nil,@"没有该联系人记录");
        }else{
            finished(contact,nil);
        }
    }
    return;
}
///保存联系人 (自动判断插入/更新)
+ (void)saveContact:(NSArray *)contactArray withFinished:(void (^)(BOOL))finished{
    if (!contactArray || contactArray.count < 1) {
        if (finished) {
            finished(NO);
        }
        return;
    }
    __block BOOL transationSucceeded = YES;
    [[LHLDBTools shareLHLDBTools].databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *resultSet;
        for (ContactModel *contactObj in contactArray){
            resultSet = [db executeQuery:@"SELECT contactID FROM Contacts WHERE contactID = ?",[NSNumber numberWithInt:contactObj.contactID.intValue]];
            if ([resultSet next]) {
                [resultSet close];
                transationSucceeded = transationSucceeded ? [db executeUpdate:@"UPDATE Contacts SET nickname = ? ,avatar = ? ,avatarURL = ? ,sex = ? ,identity = ? ,relationship = ? ,remark = ? ,pinyin = ? ,isBlocked = ? ,lastContactTime = ? ,isProvider = ? ,lisence = ? ,publishClassType = ? ,signature = ? ,birthday = ? ,telephone = ? ,email = ? WHERE contactID = ?"
                                                             ,contactObj.contactNickname
                                                             ,contactObj.contactAvatar
                                                             ,contactObj.contactAvatarURL
                                                             ,[NSNumber numberWithInt:contactObj.contactSex ]
                                                             ,[NSNumber numberWithInt:contactObj.contactIdentity]
                                                             ,[NSNumber numberWithInt:contactObj.contactRelationship]
                                                             ,contactObj.contactRemark
                                                             ,contactObj.contactPinyin
                                                             ,[NSNumber numberWithBool:contactObj.contactIsBlocked]
                                                             ,contactObj.contactLastContactTime
                                                             ,[NSNumber numberWithBool:contactObj.contactIsProvider]
                                                             ,contactObj.contactLisence
                                                             ,contactObj.contactPublishClassType
                                                             ,contactObj.contactSignature
                                                             ,contactObj.contactBirthday
                                                             ,contactObj.contactTelephone
                                                             ,contactObj.contactEmail
                                                             ,contactObj.contactID
                                                             ] : NO;
            }else{
                [resultSet close];
                transationSucceeded = transationSucceeded ? [db executeUpdate:@"INSERT INTO Contacts (contactID ,nickname ,avatar ,avatarURL ,sex ,identity ,relationship ,remark ,pinyin ,isBlocked ,lastContactTime ,isProvider ,lisence ,publishClassType ,signature ,birthday ,telephone ,email) VALUES (? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,?)"
                                                             ,contactObj.contactID
                                                             ,contactObj.contactNickname
                                                             ,contactObj.contactAvatar
                                                             ,contactObj.contactAvatarURL
                                                             ,[NSNumber numberWithInt:contactObj.contactSex ]
                                                             ,[NSNumber numberWithInt:contactObj.contactIdentity]
                                                             ,[NSNumber numberWithInt:contactObj.contactRelationship]
                                                             ,contactObj.contactRemark
                                                             ,contactObj.contactPinyin
                                                             ,[NSNumber numberWithBool:contactObj.contactIsBlocked]
                                                             ,contactObj.contactLastContactTime
                                                             ,[NSNumber numberWithBool:contactObj.contactIsProvider]
                                                             ,contactObj.contactLisence
                                                             ,contactObj.contactPublishClassType
                                                             ,contactObj.contactSignature
                                                             ,contactObj.contactBirthday
                                                             ,contactObj.contactTelephone
                                                             ,contactObj.contactEmail] : NO;
                
            }
        }
        if (!transationSucceeded){
            *rollback = YES;
        }
    }];
    if (finished) {
        finished(transationSucceeded);
    }
}

///删除联系人
+ (void)deleteContact:(NSArray *)contactArray withFinished:(void (^)(BOOL flag))finished{
    if (!contactArray || contactArray.count < 1) {
        if (finished) {
            finished(NO);
        }
    }
    __block BOOL transationSucceeded = YES;
    [[LHLDBTools shareLHLDBTools].databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (ContactModel *contactObj in contactArray){
            transationSucceeded = transationSucceeded ? [db executeUpdate:@"DELETE FROM Contacts WHERE contactID = ?"
                                                         ,contactObj.contactID] : NO;
        }
        if (!transationSucceeded){
            *rollback = YES;
        }
    }];
    if (finished) {
        finished(transationSucceeded);
    }
}

#pragma mark 最近对话
///保存最近对话信息 (更新 / 插入)
+ (void)saveConversation:(NSArray *)conversationArray withFinished:(void (^)(BOOL flag))finished{
    if (!conversationArray || conversationArray.count < 1) {
        if (finished) {
            finished(NO);
        }
        return;
    }
    __block BOOL transactionSucceeded = YES;
    [[LHLDBTools shareLHLDBTools].databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *resultSet;
        for (ConversationModel *conversation in conversationArray){
            resultSet = [db executeQuery:@"SELECT contactID FROM Conversations WHERE contactID = ?" ,conversation.conversationContactID];
            if ([resultSet next]) {  //存在
                [resultSet close];
                transactionSucceeded = transactionSucceeded ? [db executeUpdate:@"UPDATE Conversations SET lastCommunicateTime = ? ,lastChat = ? WHERE contactID = ?",
                                                               conversation.conversationLastCommunicateTime,
                                                               conversation.conversationLastChat,
                                                               conversation.conversationContactID] : NO;
            }else{
                [resultSet close];
                transactionSucceeded = transactionSucceeded ? [db executeUpdate:@"INSERT INTO Conversations (contactID ,lastCommunicateTime ,lastChat) VALUES (? ,? ,?)",
                                                               [NSNumber numberWithInteger:conversation.conversationContactID.integerValue],
                                                               conversation.conversationLastCommunicateTime,
                                                               conversation.conversationLastChat
                                                               ] : NO;
            }
        }
        if (!transactionSucceeded) {
            *rollback = YES;
        }
    }];
    if (finished) {
        finished(transactionSucceeded);
    }
}

///查找所有最近对话信息
+ (void)getConversationsWithFinished:(void (^)(NSMutableArray *conversationsArray,NSString *errorMessage))finished{
    NSMutableArray *conversations = [NSMutableArray array];
    [[LHLDBTools shareLHLDBTools].databaseQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM Conversations"];
        while ([resultSet next]) {
            ConversationModel *conversation = [LHLDBTools convertToConversationFromResultSet:resultSet];
            [conversations addObject:conversation];
        }
        [resultSet close];
        
    }];
    if (finished) {
        finished(conversations,nil);
    }
}

///转换resultSet为最近对话对象
+ (ConversationModel *)convertToConversationFromResultSet:(FMResultSet *)resultSet{
    ConversationModel *obj = [[ConversationModel alloc] init];
    obj.conversationContactID = [NSString stringWithFormat:@"%d",[resultSet intForColumn:@"contactID"]];
    obj.conversationLastCommunicateTime = [resultSet stringForColumn:@"lastCommunicateTime"];
    obj.conversationLastChat = [resultSet stringForColumn:@"lastChat"];
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
    __block BOOL executeSucceeded;
    [[LHLDBTools shareLHLDBTools].databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        executeSucceeded = [db executeUpdate:@"DELETE FROM Conversations WHERE contactID = ?",contactID];
        if (!executeSucceeded) {
            *rollback = YES;
        }
    }];
    if (finished) {
        finished(executeSucceeded);
    }
}

///删除所有最近对话
+ (void)deleteAllConversationsWithFinished:(void (^)(BOOL flag))finished{
    __block BOOL executeSucceeded;
    [[LHLDBTools shareLHLDBTools].databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        executeSucceeded = [db executeUpdate:@"DELETE FROM Conversations"];
        if (!executeSucceeded) {
            *rollback = YES;
        }
    }];
    if (finished) {
        finished(executeSucceeded);
    }
}

#pragma mark 聊天记录
///保存一条聊天记录
+ (void)saveChattingRecord:(NSArray *)chattingRecordArray withFinished:(void (^)(BOOL flag))finished{
    if (!chattingRecordArray || chattingRecordArray.count < 1) {
        if (finished) {
            finished(NO);
        }
        return;
    }
    //聊天记录不用update
    __block BOOL executeSucceeded = YES;
    [[LHLDBTools shareLHLDBTools].databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        for (MessageModel *chattingRecord in chattingRecordArray){
            executeSucceeded = executeSucceeded ? [db executeUpdate:@"INSERT INTO ChattingRecords (contactID ,time ,content ,attachment ,status, showTime) VALUES (? ,? ,? ,? ,?, ?)"
                                                   ,chattingRecord.messageRecieverID
                                                   ,chattingRecord.messageSendTime
                                                   ,chattingRecord.messageContent
                                                   ,chattingRecord.messageAttachment
                                                   ,[NSNumber numberWithInt:chattingRecord.messageStatus]
                                                   ,chattingRecord.messageShowTime
                                                   ] : NO;
        }
        if (!executeSucceeded) {
            *rollback = YES;
        }
    }];
    if (finished) {
        finished(executeSucceeded);
    }
}

///查询与某个联系人的最后N条聊天记录
+ (void)getLatestChattingRecordsWithContactID:(NSString *)contactID withFinished:(void (^)(NSArray *recordsArray,NSString *errorMessage))finished{
    if (!contactID || contactID.length < 1) {
        if (finished) {
            finished(nil,@"不正确的联系人ID");
        }
        return;
    }
    NSMutableArray *records = [NSMutableArray array];
    [[LHLDBTools shareLHLDBTools].databaseQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rst = [db executeQuery:@"SELECT * FROM ChattingRecords WHERE contactID = ? ORDER BY id DESC LIMIT ?",contactID,[NSNumber numberWithInt:kNUMBER_OF_CHAT_PER_LOAD]];
        while ([rst next]) {
            MessageModel *message = [LHLDBTools convertToMessageFromResultSet:rst];
            [records addObject:message];
        }
        [rst close];
    }];
    if (records.count > 0) {
        if (finished) {
            finished([NSArray arrayWithArray:[[records reverseObjectEnumerator] allObjects]],nil);
        }
    }else{
        if (finished) {
            finished(nil,@"未查找到记录");
        }
    }
}

///按index查询之前若干条聊天记录
+ (void)getChattingRecordsWithContactID:(NSString *)contactID beforeIndex:(NSInteger)index withFinished:(void (^)(NSArray *recordsArray,NSString *errorMessage))finished{
    if (!contactID || contactID.length < 1) {
        if (finished) {
            finished(nil,@"2不正确的联系人ID");
        }
        return;
    }
    NSMutableArray *records = [NSMutableArray array];
    [[LHLDBTools shareLHLDBTools].databaseQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rst = [db executeQuery:@"SELECT * FROM ChattingRecords WHERE contactID = ? ORDER BY id DESC LIMIT ? OFFSET ?",contactID ,[NSNumber numberWithInt:kNUMBER_OF_CHAT_PER_LOAD] ,[NSNumber numberWithInteger:index]];
        while ([rst next]) {
            MessageModel *message = [LHLDBTools convertToMessageFromResultSet:rst];
            [records addObject:message];
        }
        [rst close];
    }];
    if (records.count > 0) {
        if (finished) {
            finished([NSArray arrayWithArray:[[records reverseObjectEnumerator] allObjects]],nil);
        }
    }else{
        if (finished) {
            finished(nil,@"未查找到记录");
        }
    }
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
    __block NSInteger quantity = 0;
    [[LHLDBTools shareLHLDBTools].databaseQueue inDatabase:^(FMDatabase *db) {
        //3表示status的未读状态
        FMResultSet *rst = [db executeQuery:@"SELECT COUNT(id) quantity FROM ChattingRecords WHERE status = 3 AND contactID = ?",contactID];
        while ([rst next]) {
            quantity = [rst intForColumn:@"quantity"];
        }
        [rst close];
    }];
    if (finished) {
        finished(quantity ,nil);
    }
}

///查询某联系人所有未读消息
+ (void)getUnreadChattingRecordsWithContactID:(NSString *)contactID withFinished:(void (^)(NSArray *recordsArray ,NSString *errorMessage))finished{
    
}

///清除某联系人的未读状态
+ (void)clearUnreadStatusWithContactID:(NSString *)contactID withFinished:(void (^)(BOOL flag))finished{
    if (!contactID || contactID.length < 1) {
        if (finished) {
            finished(NO);
            return;
        }
    }
    __block BOOL executeSucceeded;
    [[LHLDBTools shareLHLDBTools].databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        executeSucceeded = [db executeUpdate:@"UPDATE ChattingRecords SET status = 4 WHERE status = 3 AND contactID = ?",contactID];
        if (!executeSucceeded) {
            *rollback = YES;
        }
    }];
    if (finished) {
        finished(executeSucceeded);
    }
}

///删除某个联系人的聊天记录
+ (void)deleteChattingRecordsWithContactID:(NSString *)contactID withFinished:(void (^)(BOOL flag))finished{
    if (!contactID || contactID.length < 1) {
        if (finished) {
            finished(NO);
        }
    }
    __block BOOL executeSucceeded;
    [[LHLDBTools shareLHLDBTools].databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        executeSucceeded = [db executeUpdate:@"DELETE FROM ChattingRecords WHERE contactID = ?",contactID];
        if (!executeSucceeded) {
            *rollback = YES;
        }
    }];
    if (finished) {
        finished(executeSucceeded);
    }
}

///删除本用户所有聊天记录
+ (void)deleteAllChattingRecordWithFinished:(void (^)(BOOL flag))finished{
    __block BOOL executeSucceeded;
    [[LHLDBTools shareLHLDBTools].databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        executeSucceeded = [db executeUpdate:@"DELETE FROM ChattingRecords"];
        if (!executeSucceeded) {
            *rollback = YES;
        }
    }];
    if (finished) {
        finished(executeSucceeded);
    }
}

///把result转换成message
+ (MessageModel *)convertToMessageFromResultSet:(FMResultSet *)resultSet{
    MessageModel *message = [[MessageModel alloc] init];
    message.messageRecieverID = [NSString stringWithFormat:@"%d",[resultSet intForColumn:@"contactID"]];
    message.messageSendTime = [resultSet stringForColumn:@"time"];
    message.messageContent = [resultSet stringForColumn:@"content"];
    message.messageAttachment = [resultSet stringForColumn:@"attachment"];
    message.messageStatus = (MessageStatus)[resultSet intForColumn:@"status"];
    message.messageShowTime = [resultSet objectForColumnName:@"showTime"];
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
