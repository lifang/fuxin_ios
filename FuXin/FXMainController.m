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

@interface FXMainController ()

@property (nonatomic, strong) FXChatListController *chatC;

@property (nonatomic, strong) FXAddressListController *addrC;

@end

@implementation FXMainController

@synthesize chatNav = _chatNav;
@synthesize addrNav = _addrNav;
@synthesize settNav = _settNav;
@synthesize chatC = _chatC;
@synthesize addrC = _addrC;

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
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(getMessageAll) userInfo:nil repeats:NO];
    [self getContactAll];
    [self showFirstData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

//加载时先从数据库加载
- (void)showFirstData {
    //从数据库初始化对话列表
    [_chatC updateChatList:[self getChatListFromDB]];
    //从数据库初始化通信录列表
    [_addrC updateContactList:[self getContactsListFromDB]];
}

//请求消息
- (void)getMessageAll {
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
                    NSMutableDictionary *messageDict = [NSMutableDictionary dictionary];
                    for (int i = 0; i < [resp.messageListsList count]; i++) {
                        MessageList *list = [resp.messageListsList objectAtIndex:i];
                        NSArray *messages = list.messagesList;
                        [messageDict setObject:messages forKey:[NSString stringWithFormat:@"%d",list.contactId]];
                    }
                    [self DBSaveMessagesWithDictionary:messageDict];
                }
                else {
                    //获取消息失败
                }
            }
            else {
                //请求失败
            }
        }];
    }
}

- (void)getContactAll {
    FXAppDelegate *delegate = [FXAppDelegate shareFXAppDelegate];
    [FXRequestDataFormat getContactListWithToken:delegate.token UserId:delegate.userID TimeStamp:nil Finished:^(BOOL success, NSData *response){
        if (success) {
            //请求成功
            ContactResponse *resp = [ContactResponse parseFromData:response];
            if (resp.isSucceed) {
                //获取联系人成功
                [self DBSaveMessageWithArray:resp.contactsList];
            }
            else {
                //获取失败
            }
        }
        else {
            //请求失败
        }
    }];
}

#pragma mark - 在未请求到数据时从数据库抓取数据

//从数据库读取对话列表
- (NSMutableArray *)getChatListFromDB {
    NSLog(@"读取数据库！");
    NSMutableArray *recentArray = [NSMutableArray array];
    [LHLDBTools getConversationsWithFinished:^(NSMutableArray *list, NSString *error) {
        for (ConversationModel *conv in list) {
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
    for (NSString *contactID in messageDict) {
        //每一个联系人的所有消息
        NSArray *messageList = [messageDict objectForKey:contactID];
        //保存聊天记录
        NSMutableArray *recordsForDB = [NSMutableArray array];
        //保存最后会话
        NSMutableArray *lastForDB = [NSMutableArray array];
        for (Message *message in messageList) {
            //聊天记录对象
            MessageModel *model = [[MessageModel alloc] init];
            model.messageRecieverID = [NSString stringWithFormat:@"%d",message.contactId];
            model.messageSendTime = message.sendTime;
            model.messageContent = message.content;
            model.messageStatus = MessageStatusUnRead;
            [recordsForDB addObject:model];
            
            //最后会话对象
            ConversationModel *conModel = [[ConversationModel alloc] init];
            conModel.conversationContactID = [NSString stringWithFormat:@"%d",message.contactId];
            conModel.conversationLastCommunicateTime = message.sendTime;
            conModel.conversationLastChat = message.content;
            [lastForDB addObject:conModel];
        }
        //插入聊天记录表
        [LHLDBTools saveChattingRecord:recordsForDB withFinished:^(BOOL finish) {
            NSLog(@"联系人id为%@的聊天信息保存%d",contactID,finish);
        }];
        //插入最后会话表
        [LHLDBTools saveConversation:lastForDB withFinished:^(BOOL finish) {
            NSLog(@"最后会话%@保存%d",contactID,finish);
        }];
        
    }
    NSLog(@"下载读取！");
    [_chatC updateChatList:[self getChatListFromDB]];
}

//将所有获取的联系人保存到数据库
- (void)DBSaveMessageWithArray:(NSArray *)contactLists {
    NSMutableArray *arrayForDB = [NSMutableArray array];
    for (Contact *contact in contactLists) {
        ContactModel *model = [[ContactModel alloc] init];
        model.contactID = [NSString stringWithFormat:@"%d",contact.contactId];
        model.contactNickname = contact.name;
        model.contactRemark = contact.customName;
        model.contactIsBlocked = contact.isBlocked;
        model.contactPinyin = contact.pinyin;
        model.contactLastContactTime = contact.lastContactTime;
        model.contactSex = contact.gender;
        model.contactRelationship = contact.source;
        model.contactAvatar = nil;
        model.contactIsProvider = contact.isProvider;
        model.contactLisence = contact.lisence;
        model.contactPublishClassType = contact.publishClassType;
        model.contactSignature = @"";
        model.contactAvatarURL = contact.tileUrl;
        [arrayForDB addObject:model];
    }
    //插入联系人表
    [LHLDBTools saveContact:arrayForDB withFinished:^(BOOL finish) {
        NSLog(@"插入联系人表%d",finish);
    }];
    
    [_addrC updateContactList:[self getContactsListFromDB]];
}

@end
