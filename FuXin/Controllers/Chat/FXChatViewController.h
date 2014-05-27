//
//  FXChatViewController.h
//  FuXin
//
//  Created by 徐宝桥 on 14-5-20.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXAdjustViewController.h"
#import "FXShowPhotoView.h"
#import "FXRequestDataFormat.h"

@interface FXChatViewController : FXAdjustViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *chatTableView;

@property (nonatomic, strong) NSMutableArray *dataItems;

@property (nonatomic, strong) FXShowPhotoView *pictureListView;

//聊天联系人信息
@property (nonatomic, strong) Contact *contact;

@end
