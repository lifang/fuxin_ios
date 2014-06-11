//
//  FXFileHelper.m
//  FuXin
//
//  Created by 徐宝桥 on 14-6-10.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXFileHelper.h"

#define kImagePath     @"chatimage"
#define kHeadImagePath @"headImage"

@implementation FXFileHelper

+ (NSString *)chatImagePath {
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [document stringByAppendingPathComponent:kImagePath];
}

+ (NSString *)headImagePath {
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [document stringByAppendingPathComponent:kHeadImagePath];
}

+ (NSString *)hashName:(NSString *)string {
    return [NSString stringWithFormat:@"%ld",(unsigned long)[[string description] hash]];
}

+ (void)documentSaveImageData:(NSData *)imageData withName:(NSString *)name withPathType:(PathTypes)type {
    NSString *directory = nil;
    switch (type) {
        case PathForChatImage: {
            directory = [[self class] chatImagePath];
        }
            break;
        case PathForHeadImage: {
            directory = [[self class] headImagePath];
        }
            break;
        default:
            break;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:directory]) {
            [fileManager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];
        }
        NSString *path = [directory stringByAppendingPathComponent:[[self class] hashName:name]];
        [fileManager createFileAtPath:path contents:imageData attributes:nil];
    });
}

+ (NSData *)chatImageAlreadyLoadWithName:(NSString *)name {
    NSString *directory = [[self class] chatImagePath];
    NSString *pathName = [directory stringByAppendingPathComponent:[[self class] hashName:name]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:pathName]) {
        return [fileManager contentsAtPath:pathName];
    }
    return nil;
}

+ (NSData *)headImageWithName:(NSString *)name {
    NSString *directory = [[self class] headImagePath];
    NSString *pathName = [directory stringByAppendingPathComponent:[[self class] hashName:name]];
    return [[NSFileManager defaultManager] contentsAtPath:pathName];
}

+ (BOOL)isHeadImageExist:(NSString *)name {
    NSString *directory = [[self class] headImagePath];
    NSString *pathName = [directory stringByAppendingPathComponent:[[self class] hashName:name]];
    return [[NSFileManager defaultManager] fileExistsAtPath:pathName];
}

+ (void)removeAncientHeadImageIfExistWithName:(NSString *)name {
    NSString *directory = [[self class] headImagePath];
    NSString *pathName = [directory stringByAppendingPathComponent:[[self class] hashName:name]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:pathName]) {
        [fileManager removeItemAtPath:pathName error:nil];
    }
}

+ (void)removeAllChatImage {
    NSString *directory = [[self class] chatImagePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:directory]) {
        [[NSFileManager defaultManager] removeItemAtPath:directory error:nil];
    }
}

@end
