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
#import "FXEmojiView.h"
#import "FXContactView.h"

//时间间隔 用于显示时间
#define kTimeInterval  300

@interface FXChatViewController : FXAdjustViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *chatTableView;

@property (nonatomic, strong) NSMutableArray *dataItems;

@property (nonatomic, strong) FXShowPhotoView *pictureListView;

@property (nonatomic, strong) FXEmojiView *emojiListView;

//聊天联系人信息
@property (nonatomic, strong) ContactModel *contact;

//上次显示timelabel的时间
@property (nonatomic, strong) NSDate *lastShowDate;

- (void)addDetailView;

@end
