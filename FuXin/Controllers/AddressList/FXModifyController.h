//
//  FXModifyController.h
//  FuXin
//
//  Created by 徐宝桥 on 14-7-16.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXAdjustViewController.h"

typedef enum {
    ModifyContact = 1,
    ModifyUser,
}ModifyType;

@interface FXModifyController : FXAdjustViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, assign) ModifyType type;
//修改联系人
@property (nonatomic, strong) ContactModel *contact;
//修改登录用户
@property (nonatomic, strong) FXUserModel *userInfo;

@property (nonatomic, strong) UITableView *modifyTable;

@end
