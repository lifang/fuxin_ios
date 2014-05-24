//
//  FXHttpRequest.h
//  FuXin
//
//  Created by 徐宝桥 on 14-5-23.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHttpHeaders.h"

@protocol FXHttpRequestDelegate;

@interface FXHttpRequest : NSObject

@property (nonatomic, assign) id<FXHttpRequestDelegate>_delegate;

- (void)setHttpRequestWithInfo:(NSDictionary *)dict;


@end

@protocol FXHttpRequestDelegate <NSObject>

- (void)requestDidFinished:(ASIHTTPRequest *)request;

@optional

- (void)requestDidFail:(ASIHTTPRequest *)request;

@end
