//
//  FXNotificationManageTableViewCell.h
//  FuXin
//
//  Created by lihongliang on 14-6-4.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXNotificationModel.h"

@interface FXNotificationManageTableViewCell : UITableViewCell
@property (strong ,nonatomic) UILabel *unreadLabel; //"new" 未读标记
@property (strong ,nonatomic) UILabel *contentLabel;

@property (strong ,nonatomic) FXNotificationModel *notificationModel;
@end
