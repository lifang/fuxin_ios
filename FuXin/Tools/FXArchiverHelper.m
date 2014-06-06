//
//  FXArchiverHelper.m
//  FuXin
//
//  Created by 徐宝桥 on 14-6-6.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXArchiverHelper.h"

@implementation FXArchiverHelper

+ (NSString *)userPath {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [documentPath stringByAppendingPathComponent:kUserPath];
}

+ (FXUserModel *)getUserInfoWithLoginName:(NSString *)loginName {
    NSArray *historyLoginUsers = [[self class] getHistoryLoginUsers];
    return [self getCurrentUserInfo:loginName fromUserArray:historyLoginUsers];
}

+ (void)saveUserInfo:(FXUserModel *)user {
    NSMutableArray *historyLoginUsers = [[self class] getHistoryLoginUsers];
    if ([historyLoginUsers containsObject:user]) {
        [historyLoginUsers removeObject:user];
    }
    [historyLoginUsers addObject:user];
}

+ (NSMutableArray *)getHistoryLoginUsers {
    NSMutableArray *historyLoginUsers = nil;
    NSString *userPath = [[self class] userPath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:userPath]) {
        NSMutableData *data = [[NSMutableData alloc] initWithContentsOfFile:userPath];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        historyLoginUsers = [unarchiver decodeObjectForKey:kHistoryLoginUsers];
    }
    return historyLoginUsers;
}

+ (void)saveDataWithArray:(NSArray *)historyUsers {
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:historyUsers forKey:kHistoryLoginUsers];
    [archiver finishEncoding];
    [data writeToFile:[[self class] userPath] atomically:YES];
}

+ (FXUserModel *)getCurrentUserInfo:(NSString *)loginName fromUserArray:(NSArray *)userArray {
    FXUserModel *currentUser = nil;
    for (FXUserModel *user in userArray) {
        if ([user.mobilePhoneNum isEqualToString:loginName] || [user.email isEqualToString:loginName]) {
            //此用户已登录过
            currentUser = user;
            break;
        }
    }
    return currentUser;
}


@end
