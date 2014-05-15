//
//  LHLDBTools.m
//  FuXin
//
//  Created by lihongliang on 14-5-14.
//  Copyright (c) 2014年 comdosoft. All rights reserved.
//

#import "LHLDBTools.h"

#define DOCUMENT_FOLDER_PATH ((NSString *)[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject])
#define DB_NAME @"FuXinDB"

@interface LHLDBTools()
@property (nonatomic,strong) FMDatabaseQueue *dbQueue;
@property (nonatomic,strong) NSString *dbPath;
@end

@implementation LHLDBTools
+(id)shareLHLDBTools{
    static LHLDBTools *dbTool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dbTool = [[LHLDBTools alloc] init];
        NSString *dbPath = [DOCUMENT_FOLDER_PATH stringByAppendingPathComponent:DB_NAME];
        dbTool.dbPath = dbPath;
        [dbTool setPath:dbPath];
        dbTool.dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbTool.dbPath];
        [dbTool setQueue:dbTool.dbQueue];
        [dbTool createTables];
    });
    return dbTool;
}

-(void)setPath:(NSString*)path{
    _databasePath = path;
}

-(void)setQueue:(FMDatabaseQueue*)databaseQueue{
    _databaseQueue = databaseQueue;
}

//TODO:创建所有表
-(void)createTables{
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        //1.创建课程表
        FMResultSet *rs = [db executeQuery:@"select name from SQLITE_MASTER where name = 'Lesson'"];
        
        if (![rs next]) {
            [rs close];
            [db executeUpdate:@"CREATE TABLE Lesson (id INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL  UNIQUE ,lessonId VARCHAR, lessonName VARCHAR,lessonCategoryId VARCHAR,lessonImageURL TEXT,lessonStudyProgress VARCHAR, lessonDetailInfo TEXT,lessonTeacherName VARCHAR,lessonDuration VARCHAR,lessonStudyTime VARCHAR,lessonScore VARCHAR,lessonIsScored VARCHAR,userId VARCHAR)"];
        }
        [rs close];
        
        //2.创建课程下的章节列表
        /*
         chapterLessonId 章节对应的课程id
         */
        rs = [db executeQuery:@"select name from SQLITE_MASTER where name = 'Chapter'"];
        if (![rs next]) {
            [rs close];
            [db executeUpdate:@"CREATE TABLE Chapter (id INTEGER PRIMARY KEY  NOT NULL , chapterId VARCHAR, chapterImg VARCHAR,chapterName VARCHAR,chapterLessonId VARCHAR,lessonCategoryId VARCHAR,userId VARCHAR)"];
        }
        
        [rs close];
        
        //3.创建章节下面的小节表
        /*
         sectionChapterId 小节对应章节id
         sectionMovieFileTotalSize 小节视频文件大小
         sectionMovieFileDownloadSize 小节视频已经下载大小
         sectionTotalPlayOfflineTime 保存离线播放时长
         */
        rs = [db executeQuery:@"select name from SQLITE_MASTER where name = 'Section'"];
        if (![rs next]) {
            [rs close];
            [db executeUpdate:@"CREATE TABLE Section (id INTEGER PRIMARY KEY  NOT NULL , sectionId VARCHAR, sectionName VARCHAR,lessonId VARCHAR,sectionChapterId VARCHAR,lessonCategoryId VARCHAR,sectionLastPlayTime VARCHAR,sectionMoviePlayURL TEXT,sectionMovieDownloadURL TEXT,sectionMovieLocalURL TEXT,sectionFinishedDate VARCHAR,sectionMovieFileDownloadStatus VARCHAR,sectionMovieFileTotalSize VARCHAR,sectionMovieFileDownloadSize VARCHAR,sectionTotalPlayOfflineTime VARCHAR,userId VARCHAR)"];
        }
        
        [rs close];
        
        
    }];
}
@end
