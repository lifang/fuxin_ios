//
//  FXFileHelper.h
//  FuXin
//
//  Created by 徐宝桥 on 14-6-10.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    PathForChatImage = 0,     //聊天图片保存地址
    PathForHeadImage,         //联系人头像保存地址
}PathTypes;

typedef void (^finishWrite)(BOOL finish);

@interface FXFileHelper : NSObject

//保存图片到相应目录
+ (void)documentSaveImageData:(NSData *)imageData
                     withName:(NSString *)name
                 withPathType:(PathTypes)type;

//保存聊天图片 未开线程
+ (void)documentSaveImageData:(NSData *)imageData withName:(NSString *)name;

//判断聊天中图片是否存在
+ (NSData *)chatImageAlreadyLoadWithName:(NSString *)name;

//判断头像是否保存
+ (BOOL)isHeadImageExist:(NSString *)name;

//获取头像
+ (NSData *)headImageWithName:(NSString *)name;

//若联系人头像修改 查找并删除旧的头像
+ (void)removeAncientHeadImageIfExistWithName:(NSString *)name;

//删除所有聊天图片
+ (void)removeAllChatImage;

@end
