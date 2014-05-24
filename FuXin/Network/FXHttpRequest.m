//
//  FXHttpRequest.m
//  FuXin
//
//  Created by 徐宝桥 on 14-5-23.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXHttpRequest.h"
#import "FXNetworkInterface.h"
#import "ModelsNew.pb.h"
#import "GTMBase64.h"

@implementation FXHttpRequest

@synthesize _delegate;

- (void)setHttpRequestWithInfo:(NSDictionary *)dict {
//    NSURL *url = [NSURL URLWithString:[dict objectForKey:kRequestURL]];
//    NSString *methodType = [dict objectForKey:kRequestType];
//    NSString *parmName = [dict objectForKey:kRequestParm];
    NSURL *url = [NSURL URLWithString:@"https://mobileim.mock.fuwu.com/api/Message"];
    NSString *methodType = @"PUT";
    
    Message *message = [[[[Message builder] setUserId:1] setContent:@"123"] build];
    SendMessageRequest *send = [[[[[SendMessageRequest builder] setToken:@"MockToken"] setUserId:2] setMessage:message] build];
    NSData *binary = [send data];
    NSString *str = [GTMBase64 stringByEncodingData:binary];
    NSString *json = [NSString stringWithFormat:@"\"%@\"",str];
    NSData *dd = [json dataUsingEncoding:NSUTF8StringEncoding];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setRequestMethod:methodType];
    [request addRequestHeader:@"Content-Type" value:@"application/xml;charset=UTF-8"];
    [request setPostBody:[NSMutableData dataWithData:dd]];
    [request setValidatesSecureCertificate:NO];
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request startAsynchronous];
    
    __weak ASIHTTPRequest *wRequest = request;
    [request setCompletionBlock:^{
        NSLog(@"!!!%@",[wRequest responseString]);
    }];
    [request setFailedBlock:^{
        NSLog(@"!!%@",[wRequest responseString]);
    }];
}

@end
