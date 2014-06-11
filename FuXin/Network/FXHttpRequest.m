//
//  FXHttpRequest.m
//  FuXin
//
//  Created by 徐宝桥 on 14-5-23.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXHttpRequest.h"

@implementation FXHttpRequest

//传入的为protobuffer二进制
+ (NSMutableData *)encodePostdataWithData:(NSData *)data {
    //base64加密
    NSString *base64String = [GTMBase64 stringByEncodingData:data];
    //JSON格式 前后加引号
    NSString *JSONString = [NSString stringWithFormat:@"\"%@\"",base64String];
    //UTF8格式
    NSData *UTF8Data = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    return [NSMutableData dataWithData:UTF8Data];
}

//传入的为返回的字符串
+ (NSData *)decodeResponseDataWithString:(NSString *)string {
    //去JSON 前后引号
    NSString *JSONString = [string substringWithRange:NSMakeRange(1, [string length] - 2)];
    //base64解密
    NSData *base64String = [GTMBase64 decodeString:JSONString];
    return base64String;
}

+ (void)setHttpRequestWithInfo:(NSDictionary *)dict responseResult:(Result)result {
    NSURL *url = [NSURL URLWithString:[dict objectForKey:kRequestURL]];
    NSString *methodType = [dict objectForKey:kRequestType];
    NSData *PBData = [dict objectForKey:kRequestPostData];
    
    NSMutableData *postData = [[self class] encodePostdataWithData:PBData];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    NSLog(@"url = %@",url);
    [request setRequestMethod:methodType];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request setPostBody:postData];
//    [request setValidatesSecureCertificate:NO];
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request startAsynchronous];

    __weak ASIHTTPRequest *wRequest = request;
    [request setCompletionBlock:^{
        NSLog(@"success");
        NSString *UTF8String = [wRequest responseString];
        NSData *PBData = [[self class] decodeResponseDataWithString:UTF8String];
        result(YES, PBData);
    }];
    [request setFailedBlock:^{
        NSLog(@"fail");
        result(NO, [wRequest responseData]);
    }];
}

@end
