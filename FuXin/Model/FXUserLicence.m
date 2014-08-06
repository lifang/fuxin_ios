//
//  FXUserLicence.m
//  FuXin
//
//  Created by 徐宝桥 on 14-7-23.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXUserLicence.h"

@implementation FXUserLicence

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_iconURL forKey:@"iconURL"];
    [aCoder encodeObject:_order forKey:@"order"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _name = [aDecoder decodeObjectForKey:@"name"];
        _iconURL = [aDecoder decodeObjectForKey:@"iconURL"];
        _order = [aDecoder decodeObjectForKey:@"order"];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    FXUserLicence *licence = [[[self class] allocWithZone:zone] init];
    licence.name = [_name copyWithZone:zone];
    licence.iconURL = [_iconURL copyWithZone:zone];
    licence.order = [_order copyWithZone:zone];
    return licence;
}

@end
