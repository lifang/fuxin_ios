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
#define kDOCUMENT_FOLDER_PATH ((NSString *)[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]) //数据库存储文件夹
#define kDB_NAME @"FuXinDB.sqlite" //数据库文件名

@interface LHLDBTools()
@property (nonatomic,strong) FMDatabaseQueue *dbQueue;
@property (nonatomic,strong) NSString *dbPath;
@end

@implementation LHLDBTools
+ (instancetype)shareLHLDBTools{
    static LHLDBTools *dbTool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dbTool = [[LHLDBTools alloc] init];
        NSString *dbPath = [kDOCUMENT_FOLDER_PATH stringByAppendingPathComponent:kDB_NAME];
        dbTool.dbPath = dbPath;
        [dbTool setPath:dbPath];
        dbTool.dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbTool.dbPath];
        [dbTool setQueue:dbTool.dbQueue];
        [dbTool createBaseTables];
        
        NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
        [formatter setDateFormat:kDATE_FORMAT];
        [dbTool setFormatter:formatter];
    });
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
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        //1.创建用户表
        /*
         UserId  : 用户ID
         UserName : 用户昵称
         UserPhotoURL : 用户头像的本地URL
         UserSex : 性别
         UserCategory : 用户类型 (福师/福客)
         */
        FMResultSet *rs = [db executeQuery:@"select name from SQLITE_MASTER where name = 'User'"];
        if (![rs next]) {
            [rs close];
            [db executeUpdate:@"CREATE TABLE User (id INTEGER PRIMARY KEY ,UserId INTEGER, UserName TEXT,UserPhotoURL TEXT,UserSex BOOLEAN,UserCategory TEXT)"];
        }
        [rs close];
        
        //2.创建聊天记录表
        /*
         发送人ID
         接收人ID
         发送时间
         内容(文本及表情)
         附件
         已读状态
         */
        rs = [db executeQuery:@"select name from SQLITE_MASTER where name = 'ChattingRecords'"];
        if (![rs next]) {
            [rs close];
            [db executeUpdate:@"CREATE TABLE ChattingRecords (id INTEGER PRIMARY KEY , )"];
        }
        
        [rs close];
        
        //3.创建用户---联系人表
        /*
         用户ID
         联系人ID
         联系人对用户的关系
         备注
         */
        rs = [db executeQuery:@"select name from SQLITE_MASTER where name = 'User_Contacts'"];
        if (![rs next]) {
            [rs close];
            [db executeUpdate:@"CREATE TABLE User_Contacts (id INTEGER PRIMARY KEY ,)"];
        }
        
        [rs close];
        
        
    }];
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
