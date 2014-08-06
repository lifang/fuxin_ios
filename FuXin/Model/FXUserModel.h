//
//  FXUserModel.h
//  FuXin
//
//  Created by 徐宝桥 on 14-6-6.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXUserLicence.h"

@interface FXUserModel : NSObject<NSCoding,NSCopying>

//id
@property (nonatomic, strong) NSNumber *userID;
//名称
@property (nonatomic, strong) NSString *name;
//昵称
@property (nonatomic, strong) NSString *nickName;
//性别 0.男  1.女 2.保密
@property (nonatomic, strong) NSNumber *genderType;
//手机
@property (nonatomic, strong) NSString *mobilePhoneNum;
//邮箱
@property (nonatomic, strong) NSString *email;
//生日
@property (nonatomic, strong) NSString *birthday;
//头像地址
@property (nonatomic, strong) NSString *tileURL;
//头像
@property (nonatomic, strong) NSData *tile;
//是否福师
@property (nonatomic, strong) NSNumber *isProvider;
//行业认证
@property (nonatomic, strong) NSString *lisence;
//实名认证
@property (nonatomic, strong) NSNumber *isAuth;
//福值
@property (nonatomic, strong) NSString *fuzhi;
//所在地
@property (nonatomic, strong) NSString *location;
//福师简介
@property (nonatomic, strong) NSString *description;

@property (nonatomic, strong) NSString *backgroundURL;

@property (nonatomic, strong, setter = setLicences:) NSArray *licences;

@end
