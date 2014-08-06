//
//  FXUserModel.m
//  FuXin
//
//  Created by 徐宝桥 on 14-6-6.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXUserModel.h"

@implementation FXUserModel


- (void)setLicences:(NSArray *)licences {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < [licences count]; i++) {
        License *licence = [licences objectAtIndex:i];
        FXUserLicence *lice = [[FXUserLicence alloc] init];
        lice.name = licence.name;
        lice.iconURL = licence.iconUrl;
        lice.order = [NSNumber numberWithInt:licence.order];
        [array addObject:lice];
    }
    _licences = array;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_userID forKey:@"userID"];
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_nickName forKey:@"nickName"];
    [aCoder encodeObject:_genderType forKey:@"genderType"];
    [aCoder encodeObject:_mobilePhoneNum forKey:@"mobilePhoneNum"];
    [aCoder encodeObject:_email forKey:@"email"];
    [aCoder encodeObject:_birthday forKey:@"birthday"];
    [aCoder encodeObject:_tileURL forKey:@"tileURL"];
    [aCoder encodeObject:_tile forKey:@"tile"];
    [aCoder encodeObject:_isProvider forKey:@"isProvider"];
    [aCoder encodeObject:_lisence forKey:@"lisence"];
    [aCoder encodeObject:_isAuth forKey:@"isAuth"];
    [aCoder encodeObject:_fuzhi forKey:@"fuzhi"];
    [aCoder encodeObject:_location forKey:@"location"];
    [aCoder encodeObject:_description forKey:@"description"];
    [aCoder encodeObject:_backgroundURL forKey:@"backgroundURL"];
    [aCoder encodeObject:_licences forKey:@"licence"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _userID = [aDecoder decodeObjectForKey:@"userID"];
        _name = [aDecoder decodeObjectForKey:@"name"];
        _nickName = [aDecoder decodeObjectForKey:@"nickName"];
        _genderType = [aDecoder decodeObjectForKey:@"genderType"];
        _mobilePhoneNum = [aDecoder decodeObjectForKey:@"mobilePhoneNum"];
        _email = [aDecoder decodeObjectForKey:@"email"];
        _birthday = [aDecoder decodeObjectForKey:@"birthday"];
        _tileURL = [aDecoder decodeObjectForKey:@"tileURL"];
        _tile = [aDecoder decodeObjectForKey:@"tile"];
        _isProvider = [aDecoder decodeObjectForKey:@"isProvider"];
        _lisence = [aDecoder decodeObjectForKey:@"lisence"];
        _isAuth = [aDecoder decodeObjectForKey:@"isAuth"];
        _fuzhi = [aDecoder decodeObjectForKey:@"fuzhi"];
        _location = [aDecoder decodeObjectForKey:@"location"];
        _description = [aDecoder decodeObjectForKey:@"description"];
        _backgroundURL = [aDecoder decodeObjectForKey:@"backgroundURL"];
        _licences = [aDecoder decodeObjectForKey:@"licence"];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    FXUserModel *user = [[[self class] allocWithZone:zone] init];
    user.userID = [_userID copyWithZone:zone];
    user.name = [_name copyWithZone:zone];
    user.nickName = [_nickName copyWithZone:zone];
    user.genderType = [_genderType copyWithZone:zone];
    user.mobilePhoneNum = [_mobilePhoneNum copyWithZone:zone];
    user.email = [_email copyWithZone:zone];
    user.birthday = [_birthday copyWithZone:zone];
    user.tileURL = [_tileURL copyWithZone:zone];
    user.tile = [_tile copyWithZone:zone];
    user.isProvider = [_isProvider copyWithZone:zone];
    user.lisence = [_lisence copyWithZone:zone];
    user.isAuth = [_isAuth copyWithZone:zone];
    user.fuzhi = [_fuzhi copyWithZone:zone];
    user.location = [_location copyWithZone:zone];
    user.description = [_description copyWithZone:zone];
    user.backgroundURL = [_backgroundURL copyWithZone:zone];
    user.licences = [_licences copyWithZone:zone];
    return user;
}

@end
