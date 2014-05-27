//
//  FXHttpRequest.h
//  FuXin
//
//  Created by 徐宝桥 on 14-5-23.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHttpHeaders.h"
#import "FXNetworkInterface.h"
#import "Models.pb.h"
#import "GTMBase64.h"

/*请求返回的结果
 success: YES 请求成功
          NO  请求失败
 response:返回的protoBuffer二进制流
 */
typedef void (^Result)(BOOL success, NSData *response);

@interface FXHttpRequest : NSObject

/*
 dict: 请求URL
       请求方式
       请求body
 */
+ (void)setHttpRequestWithInfo:(NSDictionary *)dict
                responseResult:(Result)result;

@end

