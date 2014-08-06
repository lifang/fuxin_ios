//
//  FXUserLicence.h
//  FuXin
//
//  Created by 徐宝桥 on 14-7-23.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FXUserLicence : NSObject<NSCopying,NSCoding>

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *iconURL;

@property (nonatomic, strong) NSNumber *order;

@end
