//
//  FXNotificationModel.h
//  FuXin
//
//  Created by lihongliang on 14-6-4.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FXNotificationModel : NSObject
@property (strong ,nonatomic) NSString *notiID;
@property (strong ,nonatomic) NSString *notiTitle;
@property (strong ,nonatomic) NSString *notiContent;
@property (assign ,nonatomic) BOOL notiIsReaded;
@end
