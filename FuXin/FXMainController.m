//
//  FXMainController.m
//  FuXin
//
//  Created by 徐宝桥 on 14-5-19.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXMainController.h"
#import "FXAppDelegate.h"
#import "LHLDBTools.h"
#import "Models.pb.h"
#import "FXTimeFormat.h"
#import "FXFileHelper.h"

@interface FXMainController ()

@property (nonatomic, strong) FXChatListController *chatC;

@property (nonatomic, strong) FXAddressListController *addrC;

@property (nonatomic, strong) FXReuqestError *errorHandler;

//判断是否正在加载消息信息
@property (nonatomic, assign) BOOL isRequestChatting;

@end

@implementation FXMainController

@synthesize chatNav = _chatNav;
@synthesize addrNav = _addrNav;
@synthesize settNav = _settNav;
@synthesize chatC = _chatC;
@synthesize addrC = _addrC;

@synthesize isRequestChatting = _isRequestChatting;

- (void)dealloc {
    NSLog(@"dealloc");
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tabBar.selectedImageTintColor = [UIColor redColor];
    
    [self initControllers];
    _timer = [NSTimer timerWithTimeInterval:kGetMessageDuration target:self selector:@selector(getMessageAll) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    [_timer fire];
    
//    [self getMessageAll];
    [self getContactAll];
    [self showFirstData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshChatList:) name:ChatNeedRefreshListNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAddressList:) name:AddressNeedRefreshListNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMessageAll) name:PushMessageNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getContactAll) name:UpdateContactNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//清空
- (void)cancelSource {
    [_timer invalidate];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Controllers

- (void)initControllers {
    _chatC = [[FXChatListController alloc] init];
    _chatC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"对话"
                                                      image:[UIImage imageNamed:@"chat.png"]
                                                        tag:0];
    _chatNav = [[UINavigationController alloc] initWithRootViewController:_chatC];
    [FXAppDelegate setNavigationBarTinColor:_chatNav];

    _addrC = [[FXAddressListController alloc] init];
    _addrC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"通讯录"
                                                      image:[UIImage imageNamed:@"addr.png"]
                                                        tag:1];
    _addrNav = [[UINavigationController alloc] initWithRootViewController:_addrC];
    [FXAppDelegate setNavigationBarTinColor:_addrNav];
    
    FXSettingController *settingC = [[FXSettingController alloc] init];
    settingC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"设置"
                                                        image:[UIImage imageNamed:@"setting.png"]
                                                        tag:2];
    _settNav = [[UINavigationController alloc] initWithRootViewController:settingC];
    [FXAppDelegate setNavigationBarTinColor:_settNav];
    
    self.viewControllers = [NSArray arrayWithObjects:_chatNav, _addrNav, _settNav, nil];
}

#pragma mark - Notification
//界面更新通知

- (void)refreshChatList:(NSNotification *)notification {
    [_chatC updateChatList:[self getChatListFromDB]];
}

- (void)refreshAddressList:(NSNotification *)notification {
    [_addrC updateContactList:[self getContactsListFromDB]];
}

#pragma mark - 请求消息和联系人接口

//加载时先从数据库加载
- (void)showFirstData {
    //从数据库初始化对话列表
    [_chatC updateChatList:[self getChatListFromDB]];
    //从数据库初始化通信录列表
    [_addrC updateContactList:[self getContactsListFromDB]];
}

//请求消息
- (void)getMessageAll {
    NSLog(@"get message");
    if (_isRequestChatting) {
        return;
    }
    _isRequestChatting = YES;
    FXAppDelegate *delegate = [FXAppDelegate shareFXAppDelegate];
    if (delegate.token && delegate.userID >= 0) {
        [FXRequestDataFormat getMessageWithToken:delegate.token UserID:delegate.userID TimeStamp:delegate.messageTimeStamp Finished:^(BOOL success, NSData *response) {
            if (success) {
                //请求成功
                MessageResponse *resp = [MessageResponse parseFromData:response];
                if (resp.isSucceed) {
                    //获取消息成功
                    //保存时间戳
                    delegate.messageTimeStamp = resp.timeStamp;
                    //保存时间戳到本地
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                        NSString *messageTimeStamp = [NSString stringWithFormat:@"%d_messageTimeStamp",delegate.userID];
                        [defaults setObject:resp.timeStamp forKey:messageTimeStamp];
                        [defaults synchronize];
                    });
                    
                    NSMutableDictionary *messageDict = [NSMutableDictionary dictionary];
                    for (int i = 0; i < [resp.messageListsList count]; i++) {
                        MessageList *list = [resp.messageListsList objectAtIndex:i];
                        NSArray *messages = list.messagesList;
                        NSLog(@"^^^^");
                        NSLog(@"消息数%d,contactID = %d",[messages count],list.contactId);
                        for (Message *mess in messages) {
                            NSLog(@"userID = %d, contactID = %d,content = %@, sendTime = %@",mess.userId,mess.contactId,mess.content,mess.sendTime);
                        }
                        NSLog(@"=---=");
                        [messageDict setObject:messages forKey:[NSString stringWithFormat:@"%d",list.contactId]];
                    }
                    [self DBSaveMessagesWithDictionary:messageDict];
                    if (delegate.isChatting) {
                        //正在聊天
                        [[NSNotificationCenter defaultCenter] postNotificationName:ChatUpdateMessageNotification object:nil userInfo:messageDict];
                    }
                }
                else {
                    //获取消息失败
                    if (!self.errorHandler) {
                        self.errorHandler = [[FXReuqestError alloc] init];
                    }
                    [self.errorHandler requestDidFailWithErrorCode:resp.errorCode];
                }
            }
            else {
                //请求失败
            }
            _isRequestChatting = NO;
        }];
    }
}

- (void)getContactAll {
    FXAppDelegate *delegate = [FXAppDelegate shareFXAppDelegate];
    [FXRequestDataFormat getContactListWithToken:delegate.token UserId:delegate.userID TimeStamp:delegate.contactTimeStamp Finished:^(BOOL success, NSData *response){
        //用于联系人下拉刷新返回状态
        NSMutableDictionary *responseDict = [NSMutableDictionary dictionary];
        if (success) {
            //请求成功
            ContactResponse *resp = [ContactResponse parseFromData:response];
            if (resp.isSucceed) {
                //保存时间戳
                delegate.contactTimeStamp = resp.timeStamp;
                //保存时间戳到本地
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    NSString *contactTimeStamp = [NSString stringWithFormat:@"%d_contactTimeStamp",delegate.userID];
                    [defaults setObject:resp.timeStamp forKey:contactTimeStamp];
                    [defaults synchronize];
                });
                NSLog(@"新改联系人数量：%d",[resp.contactsList count]);
                //获取联系人成功
                [self DBSaveMessageWithArray:resp.contactsList];
                [responseDict setObject:[NSNumber numberWithBool:YES] forKey:@"result"];
            }
            else {
                //获取失败
                [responseDict setObject:[NSNumber numberWithBool:NO] forKey:@"result"];
                if (!self.errorHandler) {
                    self.errorHandler = [[FXReuqestError alloc] init];
                }
                [self.errorHandler requestDidFailWithErrorCode:resp.errorCode];
            }
        }
        else {
            [responseDict setObject:[NSNumber numberWithBool:NO] forKey:@"result"];
            //请求失败
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:RequestFinishNotification object:nil userInfo:responseDict];
    }];
}

#pragma mark - 在未请求到数据时从数据库抓取数据

//从数据库读取对话列表
- (NSMutableArray *)getChatListFromDB {
//    NSLog(@"读取数据库！");
    NSMutableArray *recentArray = [NSMutableArray array];
    [LHLDBTools getConversationsWithFinished:^(NSMutableArray *list, NSString *error) {
        for (ConversationModel *conv in list) {
            //如果对话id和登录用户相同 不显示
            FXAppDelegate *delegate = [FXAppDelegate shareFXAppDelegate];
            if (delegate.userID == [conv.conversationContactID intValue]) {
                continue;
            }
            NSMutableDictionary *recentChat = [NSMutableDictionary dictionary];
            [recentChat setValue:conv.conversationContactID forKey:@"ID"];
            [recentChat setValue:conv.conversationLastCommunicateTime forKey:@"Time"];
            [recentChat setValue:conv.conversationLastChat forKey:@"Record"];
            //查未读消息数量
            [LHLDBTools numberOfUnreadChattingRecordsWithContactID:conv.conversationContactID withFinished:^(NSInteger number, NSString *error) {
                [recentChat setValue:[NSNumber numberWithInteger:number] forKey:@"Number"];
            }];
            //查联系人信息
            [LHLDBTools findContactWithContactID:conv.conversationContactID withFinished:^(ContactModel *con, NSString *error) {
                [recentChat setValue:con forKey:@"Contact"];
            }];
            [recentArray addObject:recentChat];
        }
    }];
    
    return recentArray;
}

//从数据库读取联系人列表
- (NSMutableArray *)getContactsListFromDB {
    NSMutableArray *contactArray = [NSMutableArray array];
    [LHLDBTools getAllContactsWithFinished:^(NSArray *list, NSString *error) {
        [contactArray addObjectsFromArray:list];
    }];
    return contactArray;
}

#pragma mark - 将接收数据转化成数据库表字段存取

//将所有获取的对话数据保存到数据库
- (void)DBSaveMessagesWithDictionary:(NSDictionary *)messageDict {
    __block NSMutableArray *lastCovs = nil;
    [LHLDBTools getConversationsWithFinished:^(NSMutableArray *covs,NSString *error) {
        lastCovs = covs;
    }];
    
/*
 2014年7月30日新改需求--------
 */
    FXAppDelegate *delegate = [FXAppDelegate shareFXAppDelegate];
    //自己发送的消息
//    NSArray *sendList = [messageDict objectForKey:[NSString stringWithFormat:@"%d",delegate.userID]];
//-------------------------------
    for (NSString *contactID in messageDict) {
        //如果对话id和登录用户相同 不保存 (保存到发送人的地方)
        if (delegate.userID == [contactID intValue]) {
            continue;
        }
        //每一个联系人的所有消息
        NSArray *messageList = [messageDict objectForKey:contactID];
        //保存聊天记录
        NSMutableArray *recordsForDB = [NSMutableArray array];
        //保存最后会话
        NSMutableArray *lastForDB = [NSMutableArray array];
        NSString *timeString = nil;
        //找到此联系人的最后聊天时间
        for (ConversationModel *cover in lastCovs) {
            if ([cover.conversationContactID isEqualToString:contactID]) {
                timeString = cover.conversationLastCommunicateTime;
                break;
            }
        }
        for (int i = [messageList count] - 1; i >= 0; i--) {
            Message *message = [messageList objectAtIndex:i];
//            NSLog(@"接收：send = %d,user = %d,%@",message.contactId,message.userId,message.content);
            //聊天记录对象
            MessageModel *model = [[MessageModel alloc] init];
            if (delegate.userID == message.contactId) {
                //发送的消息
                model.messageRecieverID = [NSString stringWithFormat:@"%d",message.userId];
                model.messageStatus = MessageStatusDidSent;
            }
            else if (delegate.userID == message.userId) {
                //接收的消息
                model.messageRecieverID = [NSString stringWithFormat:@"%d",message.contactId];
                model.messageStatus = MessageStatusUnRead;
            }
            model.messageSendTime = message.sendTime;
            model.messageContent = message.content;
            //是否显示时间*********************************
            if (!timeString) {
                timeString = message.sendTime;
                model.messageShowTime = [NSNumber numberWithBool:YES];
            }
            else {
                BOOL needShowTime = [FXTimeFormat needShowTime:timeString withTime:message.sendTime];
                if (needShowTime) {
                    timeString = message.sendTime;
                    model.messageShowTime = [NSNumber numberWithBool:YES];
                }
                else {
                    model.messageShowTime = [NSNumber numberWithBool:NO];
                }
            }
            //********************************************
            model.messageType = (ContentType)message.contentType;
            model.imageContent = message.binaryContent;
            [recordsForDB addObject:model];
            
            //最后会话对象
            ConversationModel *conModel = [[ConversationModel alloc] init];
            if (delegate.userID == message.contactId) {
                //发送的消息
                conModel.conversationContactID = [NSString stringWithFormat:@"%d",message.userId];
            }
            else if (delegate.userID == message.userId) {
                //接收的消息
                conModel.conversationContactID = [NSString stringWithFormat:@"%d",message.contactId];
            }
            conModel.conversationLastCommunicateTime = message.sendTime;
            if (message.contentType == Message_ContentTypeText) {
                conModel.conversationLastChat = message.content;
            }
            else if (message.contentType == Message_ContentTypeImage) {
                conModel.conversationLastChat = @"[图片]";
            }
            else if (message.contentType == Message_ContentTypeNotice) {
                conModel.conversationLastChat = @"系统消息";
            }
            [lastForDB addObject:conModel];
        }
//从自己发送信息的列表中找到发给此人的消息
/*
        for (int i = 0; i < [sendList count]; i++) {
            Message *send = [sendList objectAtIndex:i];
//            NSLog(@"发送：send = %d,user = %d,%@",send.contactId,send.userId,send.content);
            //聊天记录对象
            MessageModel *model = [[MessageModel alloc] init];
            model.messageRecieverID = [NSString stringWithFormat:@"%d",send.userId];
            model.messageSendTime = send.sendTime;
            model.messageContent = send.content;
            model.messageStatus = MessageStatusDidSent;
            //是否显示时间*********************************
            if (!timeString) {
                timeString = send.sendTime;
                model.messageShowTime = [NSNumber numberWithBool:YES];
            }
            else {
                BOOL needShowTime = [FXTimeFormat needShowTime:timeString withTime:send.sendTime];
                if (needShowTime) {
                    timeString = send.sendTime;
                    model.messageShowTime = [NSNumber numberWithBool:YES];
                }
                else {
                    model.messageShowTime = [NSNumber numberWithBool:YES];
                }
            }

            model.messageType = (ContentType)send.contentType;
            model.imageContent = send.binaryContent;
            [recordsForDB addObject:model];
            
            //最后会话对象
            ConversationModel *conModel = [[ConversationModel alloc] init];
            conModel.conversationContactID = [NSString stringWithFormat:@"%d",send.userId];
            conModel.conversationLastCommunicateTime = send.sendTime;
            if (send.contentType == Message_ContentTypeText) {
                conModel.conversationLastChat = send.content;
            }
            else {
                conModel.conversationLastChat = @"[图片]";
            }
            [lastForDB addObject:conModel];
        }
 */
//----------------------------------------------------------
//排序
//        NSArray *sortRecord = [self sortRecordArrayWithArray:recordsForDB];
//        NSArray *sortConversion = [self sortConversionArrayWithArray:lastForDB];
        NSArray *sortRecord = [[recordsForDB reverseObjectEnumerator] allObjects];
        NSArray *sortConversion = [[lastForDB reverseObjectEnumerator] allObjects];
        //插入聊天记录表
        [LHLDBTools saveChattingRecord:sortRecord withFinished:^(BOOL finish) {
            NSLog(@"联系人id为%@的聊天信息保存%d",contactID,finish);
        }];
        //插入最后会话表
        [LHLDBTools saveConversation:sortConversion withFinished:^(BOOL finish) {
            NSLog(@"最后会话%@保存%d",contactID,finish);
        }];
        
    }
//    NSLog(@"下载读取！");
    [_chatC updateChatList:[self getChatListFromDB]];
}

//聊天记录排序插入到数据库
- (NSArray *)sortRecordArrayWithArray:(NSArray *)recordList {
    NSLog(@"数量：%d",[recordList count]);
    return [recordList sortedArrayUsingComparator:^NSComparisonResult(MessageModel *model1, MessageModel *model2) {
        NSDate *date1 = [FXTimeFormat dateWithString:model1.messageSendTime];
        NSDate *date2 = [FXTimeFormat dateWithString:model2.messageSendTime];
        NSComparisonResult result = [date1 compare:date2];
        return result;
    }];
}

//最后记录排序插入到数据库
- (NSArray *)sortConversionArrayWithArray:(NSArray *)lastList {
    return [lastList sortedArrayUsingComparator:^NSComparisonResult(ConversationModel *model1, ConversationModel *model2) {
        NSDate *date1 = [FXTimeFormat dateWithString:model1.conversationLastCommunicateTime];
        NSDate *date2 = [FXTimeFormat dateWithString:model2.conversationLastCommunicateTime];
        NSComparisonResult result = [date1 compare:date2];
        return result;
    }];
}



//将URL中得反斜杠换成斜杠
- (NSString *)urlStringFormatWithString:(NSString *)url {
    return [url stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
}

//将所有获取的联系人保存到数据库
- (void)DBSaveMessageWithArray:(NSArray *)contactLists {
    NSMutableArray *arrayForDB = [NSMutableArray array];
    for (Contact *contact in contactLists) {
        NSLog(@"!!!%@,%@,%d,%d",contact.name,contact.customName,contact.contactId,contact.source);
        ContactModel *model = [[ContactModel alloc] init];
        model.contactID = [NSString stringWithFormat:@"%d",contact.contactId];
        model.contactNickname = contact.name;
        model.contactRemark = contact.customName;
        model.contactIsBlocked = contact.isBlocked;
        model.contactPinyin = contact.pinyin;
        model.contactLastContactTime = contact.lastContactTime;
        model.contactSex = (ContactSex)contact.gender;
        model.contactRelationship = contact.source;
        model.contactAvatar = nil;
        model.contactIsProvider = contact.isProvider;
        model.contactLisence = contact.lisence;
        model.contactSignature = contact.individualResume;
        model.orderTime = contact.orderTime;
        model.subscribeTime = contact.subscribeTime;
        
        NSString *tileURLFormat = [self urlStringFormatWithString:contact.tileUrl];
        if ([FXFileHelper isHeadImageExist:tileURLFormat]) {
            //若头像存在 说明未修改 直接保存
            model.contactAvatarURL = tileURLFormat;
        }
        else {
            [LHLDBTools getAllContactsWithFinished:^(NSArray *contactList, NSString *error) {
                for (ContactModel *oldC in contactList) {
                    if ([oldC.contactID isEqualToString:model.contactID]) {
                        //删除旧的头像
                        [FXFileHelper removeAncientHeadImageIfExistWithName:oldC.contactAvatarURL];
                        break;
                    }
                }
            }];
            model.contactAvatarURL = tileURLFormat;
        }
        [arrayForDB addObject:model];
    }
    //系统消息联系人
    [arrayForDB addObject:[self setSystemMessageContact]];
    
    //插入联系人表
    [LHLDBTools saveContact:arrayForDB withFinished:^(BOOL finish) {
        NSLog(@"插入联系人表%d",finish);
    }];
    
    [_addrC updateContactList:[self getContactsListFromDB]];
    
    [_chatC updateChatList:[self getChatListFromDB]];
}

/*
 2014年8月7日新加
 系统消息联系人：此联系人移动端写死
 */

- (ContactModel *)setSystemMessageContact {
    ContactModel *system = [[ContactModel alloc] init];
    system.contactID = [NSString stringWithFormat:@"%d",kSystemContactID];
    system.contactNickname = @"系统消息";
    system.contactRemark = @"系统消息";
    system.contactIsBlocked = NO;
    system.contactSex = ContactSexSecret;
    system.location = @"来自上海";
    system.contactIsProvider = NO;
    return system;
}


@end
