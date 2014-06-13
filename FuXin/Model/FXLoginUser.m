//
//  FXLoginUser.m
//  FuXin
//
//  Created by 徐宝桥 on 14-6-13.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXLoginUser.h"

@implementation FXLoginUser

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_username forKey:@"username"];
    [aCoder encodeObject:_password forKey:@"password"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _username = [aDecoder decodeObjectForKey:@"username"];
        _password = [aDecoder decodeObjectForKey:@"password"];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    FXLoginUser *user = [[[self class] allocWithZone:zone] init];
    user.username = [_username copyWithZone:zone];
    user.password = [_password copyWithZone:zone];
    return user;
}


@end
