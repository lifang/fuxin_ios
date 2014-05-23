//
//  SharedClass.m
//  FuXin
//
//  Created by lihongliang on 14-5-19.
//  Copyright (c) 2014年 comdosoft. All rights reserved.
//

#import "SharedClass.h"
static SharedClass *singleton = nil;

@implementation SharedClass
+ (instancetype)sharedObject{
    static SharedClass*  sharedObj = nil;
    if (!sharedObj){
        sharedObj = [[self alloc] init];
    };
    return sharedObj;
}
@end
