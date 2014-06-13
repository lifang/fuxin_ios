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
    if (!historyLoginUsers) {
        historyLoginUsers = [[NSMutableArray alloc] init];
    }
    NSInteger index = -1;
    for (int i = 0; i < [historyLoginUsers count]; i++) {
        FXUserModel *historyUser = [historyLoginUsers objectAtIndex:i];
        if ([historyUser.userID isEqualToNumber:user.userID]) {
            index = i;
            break;
        }
    }
    if (index >= 0) {
        [historyLoginUsers removeObjectAtIndex:index];
    }
    [historyLoginUsers addObject:user];
    [self saveDataWithArray:historyLoginUsers];
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

#pragma mark - 用户信息

+ (NSString *)userLoginInfoPath {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [documentPath stringByAppendingPathComponent:kUserInfoPath];
}

+ (void)saveUserPassword:(FXLoginUser *)user {
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:user forKey:kLoginUser];
    [archiver finishEncoding];
    [data writeToFile:[[self class] userLoginInfoPath] atomically:YES];
}

+ (FXLoginUser *)getUserPassword {
    NSString *userPath = [[self class] userLoginInfoPath];
    NSMutableData *data = [[NSMutableData alloc] initWithContentsOfFile:userPath];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    return [unarchiver decodeObjectForKey:kLoginUser];
}

+ (void)print {
    NSMutableArray *history = [[self class] getHistoryLoginUsers];
    for (FXUserModel *model in history) {
        NSLog(@"^^^^^^^^^^^^^^^^");
        NSLog(@"id = %@",model.userID);
        NSLog(@"name = %@",model.name);
        NSLog(@"nick = %@",model.nickName);
        NSLog(@"gender = %@",model.genderType);
        NSLog(@"mob = %@",model.mobilePhoneNum);
        NSLog(@"email = %@",model.email);
        NSLog(@"birth = %@",model.birthday);
        NSLog(@"url = %@",model.tileURL);
        NSLog(@"tile = %lu",(unsigned long)[model.tile length]);
        NSLog(@"pro = %@",model.isProvider);
        NSLog(@"lis = %@",model.lisence);
        NSLog(@"fuzhi = %@",model.fuzhi);
    }
}


@end
