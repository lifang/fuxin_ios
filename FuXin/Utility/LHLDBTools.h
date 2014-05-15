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
///数据库操作单利
@property (nonatomic,strong,readonly) FMDatabaseQueue *databaseQueue;
@end
