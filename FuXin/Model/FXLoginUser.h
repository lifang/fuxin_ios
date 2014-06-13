//
//  FXLoginUser.h
//  FuXin
//
//  Created by 徐宝桥 on 14-6-13.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FXLoginUser : NSObject<NSCopying,NSCoding>

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;

@end
