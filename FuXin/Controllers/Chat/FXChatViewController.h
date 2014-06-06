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
#define kTimeInterval  30

@interface FXChatViewController : FXAdjustViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *chatTableView;

@property (nonatomic, strong) NSMutableArray *dataItems;

@property (nonatomic, strong) FXShowPhotoView *pictureListView;

@property (nonatomic, strong) FXEmojiView *emojiListView;

//聊天联系人信息
@property (nonatomic, strong) ContactModel *contact;

//聊天联系人ID，因为contact是从通讯录列表查出，所以需要单独记录
@property (nonatomic, strong) NSString *ID;

//上次显示timelabel的时间
@property (nonatomic, strong) NSDate *lastShowDate;

//联系人详细界面
@property (nonatomic, strong) FXContactView *contactView;

@property (nonatomic, strong) UIRefreshControl *refreshControl;

//添加联系人详细界面
- (void)addDetailView;

//修改联系人备注
- (void)modifyContactRemark:(NSString *)remark;
//正在聊天时获取数据加在数组最后
- (void)addMessagesWhileChatting:(NSDictionary *)dict;

@end
