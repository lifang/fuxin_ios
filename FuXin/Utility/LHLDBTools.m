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
@property (nonatomic,strong) NSString *userID; //数据库对应的userID
@end

@implementation LHLDBTools

//单例实现1
//+ (instancetype)shareLHLDBTools{
//    static LHLDBTools *dbTool = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        dbTool = [[LHLDBTools alloc] init];
//        NSString *dbPath = [kDOCUMENT_FOLDER_PATH stringByAppendingPathComponent:kDB_NAME];
//        dbTool.dbPath = dbPath;
//        [dbTool setPath:dbPath];
//        dbTool.dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbTool.dbPath];
//        [dbTool setQueue:dbTool.dbQueue];
//        [dbTool createBaseTables];
//        
//        NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
//        [formatter setDateFormat:kDATE_FORMAT];
//        [dbTool setFormatter:formatter];
//    });
//    return dbTool;
//}

///单例实现2,根据单例中的userID返回单例.
+ (instancetype)shareLHLDBTools{
    static LHLDBTools *dbTool = nil;
    if ([SharedClass sharedObject].userID == nil) {
        return nil;
    }
    if (!dbTool || ![dbTool.userID isEqualToString:[SharedClass sharedObject].userID]) {  //如果无对象,或者对象userID不同 ,则创建对象
        dbTool = [[LHLDBTools alloc] init];
        NSString *dbPath = [kUSER_FOLDER_PATH stringByAppendingPathComponent:kDB_NAME];
        [dbTool setPath:dbPath];
        [dbTool setQueue:[FMDatabaseQueue databaseQueueWithPath:dbPath]];
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
        
        //2.创建聊天记录表
        /*
         联系人ID
         发送时间
         内容(文本及表情)
         附件
         状态(已发送 / 已读 /未发送 /未读)
         */
        FMResultSet *rs = [db executeQuery:@"select name from SQLITE_MASTER where name = 'ChattingRecords'"];
        if (![rs next]) {
            [rs close];
            [db executeUpdate:@"CREATE TABLE ChattingRecords (id INTEGER PRIMARY KEY , contactID INTEGER , time TEXT , content TEXT ,attachment TEXT , status NUMBERIC)"];
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
        rs = [db executeQuery:@"select name from SQLITE_MASTER where name = 'Contacts'"];
        if (![rs next]) {
            [rs close];
            [db executeUpdate:@"CREATE TABLE Contacts (id INTEGER PRIMARY KEY ,contactID INTEGER ,nickname TEXT,avatar TEXT ,sex NUMBERIC ,identity NUMBERIC ,relationship NUMBERIC , remark TEXT)"];
        }
        
        [rs close];
        
        //4.创建最近对话表
        /*
         联系人ID ,
         最后对话时间
         */
        rs = [db executeQuery:@"select name from SQLITE_MASTER where name = 'conversations'"];
        if (![rs next]) {
            [rs close];
            [db executeUpdate:@"CREATE TABLE conversations (id INTEGER PRIMARY KEY ,contactID INTEGER , lastCommunicateTime TEXT)"];
        }
        
        [rs close];
    }];
}

#pragma mark 联系人
///查找所有联系人
+ (NSArray *)getAllContacts{
    [[LHLDBTools shareLHLDBTools].databaseQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *resultSet = [db executeQuery:@""];
        while ([resultSet next]) {
            
        }
    }];
    return nil;
}
///根据联系人ID查找联系人
+ (id)findContactWithContactID:(NSString *)contactID{
    return nil;
}
///保存联系人
+ (void)saveContact:(id)contact{
    
}

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
