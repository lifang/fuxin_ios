//
//  FXChatViewController.m
//  FuXin
//
//  Created by 徐宝桥 on 14-5-20.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

//

#import "FXChatViewController.h"
#import "KxMenu.h"
#import "FXChatInputView.h"
#import "FXMessageBoxCell.h"
#import "FXKeyboardAnimation.h"
#import "FXAppDelegate.h"
#import "LHLDBTools.h"
#import "FXTimeFormat.h"
#import "Models.pb.h"
#import "FXDetailImageView.h"
#import "FXFileHelper.h"
#import "FXInfoView.h"

#define kSmallImage   @"&width=216&height=144"

static NSString *MessageCellIdentifier = @"MCI";

@interface FXChatViewController ()<GetInputTextDelegate,PictureButtonDelegate,EmojiDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,TouchContactDelegate>

@property (nonatomic, strong) FXChatInputView *inputView;

@property (nonatomic, assign) BOOL showListView;

@property (nonatomic, assign) BOOL showEmojiView;

@property (nonatomic, assign) BOOL showKeyBoard;

@property (nonatomic, assign) CGFloat keyboardHeight;

//用户头像 从delegate.user读出 单独拿出来主要是防止频繁由NSData转换成UIImage
@property (nonatomic, strong) UIImage *userImage;

@property (nonatomic, strong) ContactModel *contactDetail;

@property (nonatomic, strong) FXInfoView *infoView;   //提示框

@end

@implementation FXChatViewController

@synthesize inputView = _inputView;

@synthesize chatTableView = _chatTableView;
@synthesize dataItems = _dataItems;
@synthesize pictureListView = _pictureListView;
@synthesize showListView = _showListView;
@synthesize showEmojiView = _showEmojiView;
@synthesize showKeyBoard = _showKeyBoard;
@synthesize contact = _contact;
@synthesize ID = _ID;
@synthesize emojiListView = _emojiListView;
@synthesize contactView = _contactView;
@synthesize refreshControl = _refreshControl;
@synthesize keyboardHeight = _keyboardHeight;
@synthesize userImage = _userImage;
@synthesize contactDetail = _contactDetail;
@synthesize infoView = _infoView;

- (void)dealloc {
    //注销掉键盘通知
    [[NSNotificationCenter defaultCenter] removeObserver:_inputView];
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
    self.view.backgroundColor = [UIColor whiteColor];
    [self setLeftNavBarItemWithImageName:@"back.png"];
    [self setRightNavBarItemWithImageName:@"info.png"];
    [self initUI];
    [self showChatMessage];
    FXAppDelegate *delegate = [FXAppDelegate shareFXAppDelegate];
    delegate.isChatting = YES;
    if (delegate.user.tile) {
        _userImage = [UIImage imageWithData:delegate.user.tile];
    }
    else {
        _userImage = [UIImage imageNamed:@"placeholder.png"];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addMessagesWhileChatting:) name:ChatUpdateMessageNotification object:nil];
    if (_contact.contactRemark && ![_contact.contactRemark isEqualToString:@""]) {
        self.title = _contact.contactRemark;
    }
    else {
        self.title = _contact.contactNickname;
    }
    
    //删除未读标志
    [LHLDBTools clearUnreadStatusWithContactID:_ID withFinished:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:ChatNeedRefreshListNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"chattingWithSomeone"];

}

- (void)viewDidDisappear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"chattingWithSomeone"];
}


#pragma mark - UI

- (void)initUI {
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    _chatTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, kScreenHeight - 64 - kInputViewHeight) style:UITableViewStylePlain];
    _chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _chatTableView.delegate = self;
    _chatTableView.dataSource = self;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    view.backgroundColor = _chatTableView.backgroundColor;
    _chatTableView.tableHeaderView = view;
    [_chatTableView addSubview:_refreshControl];
    [_chatTableView registerClass:[FXMessageBoxCell class] forCellReuseIdentifier:MessageCellIdentifier];
    [self.view addSubview:_chatTableView];
    //清除多余划线
    [self hiddenExtraCellLine];
    
    _inputView = [[FXChatInputView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 64 - kInputViewHeight, 320, kInputViewHeight)];
    _inputView.inputDelegate = self;
    [self.view addSubview:_inputView];
    
    _dataItems = [[NSMutableArray alloc] init];
    
    [self initPictureListView];
    [self initEmojiView];
    
    [self initInfoView];
}

- (void)hiddenExtraCellLine {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [_chatTableView setTableFooterView:view];
}

//添加图片菜单
- (void)initPictureListView {
    _pictureListView = [[FXShowPhotoView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 64, 320, 216)];
    _pictureListView.pictureDelegate = self;
    [self.view addSubview:_pictureListView];
}

//表情菜单
- (void)initEmojiView {
    _emojiListView = [[FXEmojiView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 64, 320, 216)];
    _emojiListView.emojiDelegate = self;
    [self.view addSubview:_emojiListView];
}

//提示框
- (void)initInfoView {
    CGFloat originY = (kScreenHeight - 64 - 40) / 2;
    _infoView = [[FXInfoView alloc] initWithFrame:CGRectMake(100, originY, 120, 40)];
    _infoView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    _infoView.layer.cornerRadius = 4;
    _infoView.layer.masksToBounds = YES;
    _infoView.hidden = YES;
    [self.view addSubview:_infoView];
}

////联系人详细
//- (void)addDetailView {
//    if (!_contactView) {
//        _contactView = [[FXContactView alloc] initWithFrame:CGRectMake(0, 0, 320, kScreenHeight - 64)];
//        [self.view addSubview:_contactView];
//    }
//    if (_contactDetail) {
//        _contactView.contact = _contactDetail;
//    }
//    else {
//        _contactView.contact = _contact;
//    }
//    if (_contactView.hidden) {
//        _contactView.hidden = NO;
//        _contactView.alpha = 1.0f;
//    }
//    //若没有请求过联系人详细信息或请求联系人详细信息失败
//    if (!_contactDetail) {
//        FXAppDelegate *delegate = [FXAppDelegate shareFXAppDelegate];
//        [FXRequestDataFormat getContactDetailWithToken:delegate.token UserID:delegate.userID ContactID:[_contact.contactID intValue] Finished:^(BOOL success, NSData *response) {
//            if (success) {
//                //请求成功
//                ContactDetailResponse *resp = [ContactDetailResponse parseFromData:response];
//                NSLog(@"联系人详情：%d",resp.isSucceed);
//                if (resp.isSucceed) {
//                    //获取成功
//                    [self setContactWithContact:resp.contact];
//                    _contactView.contact = _contactDetail;
//                }
//                else {
//                    //获取失败
//                }
//            }
//            else {
//                //请求失败
//            }
//        }];
//    }
//}

#pragma mark - 下拉刷新

- (void)refresh {
    if (_refreshControl.refreshing) {
        [LHLDBTools getChattingRecordsWithContactID:_ID beforeIndex:[_dataItems count] withFinished:^(NSArray *records, NSString *error) {
            //插入数组
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [records count])];
            [_dataItems insertObjects:records atIndexes:indexSet];
        
            [_chatTableView reloadData];
            if ([records count] > 0) {
                NSIndexPath *path = [NSIndexPath indexPathForRow:[records count] inSection:0];
                [_chatTableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
            //停止刷新
            [self stopRefresh];
        }];
    }
}

- (void)stopRefresh {
    [_refreshControl endRefreshing];
}

#pragma mark - 重写父类方法

- (void)back:(id)sender {
    FXAppDelegate *delegate = [FXAppDelegate shareFXAppDelegate];
    delegate.isChatting = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (_isFromDetail) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else {
        [super back:sender];
    }
}

//重写导航右按钮方法
- (IBAction)rightBarTouched:(id)sender {
    NSMutableArray *listArray = [NSMutableArray arrayWithObjects:
                                 [KxMenuItem menuItem:@"清除聊天记录"
                                                image:nil
                                               target:self
                                               action:@selector(cleanUp:)],
                                 nil];
//    if (!_contact.contactIsBlocked) {
//        [listArray insertObject:[KxMenuItem menuItem:@"屏蔽此人"
//                                              image:nil
//                                              target:self action:@selector(hiddenUser:)]
//                        atIndex:1];
//    }
    CGRect rect = CGRectMake(280, 0, 20, 0);
    [KxMenu showMenuInView:self.view fromRect:rect menuItems:listArray];
}

//#pragma mark - 修改联系人
//
//- (void)modifyContactRemark:(NSString *)remark {
//    Contact *contact = [[[[[[[[[[[[[[Contact builder]
//                                    setContactId:[_contact.contactID intValue]]
//                                   setName:_contact.contactNickname]
//                                  setCustomName:remark]
//                                 setPinyin:_contact.contactPinyin]
//                                setIsBlocked:_contact.contactIsBlocked]
//                               setLastContactTime:_contact.contactLastContactTime]
//                              setGender:(Contact_GenderType)_contact.contactSex]
//                             setSource:_contact.contactRelationship]
//                            setTileUrl:_contact.contactAvatarURL]
//                           setIsProvider:_contact.contactIsProvider]
//                          setLisence:_contact.contactLisence]
//                         setIndividualResume:_contact.contactSignature] build];
//    FXAppDelegate *delegate = [FXAppDelegate shareFXAppDelegate];
//    [FXRequestDataFormat modifyContactDetailWithToken:delegate.token UserID:delegate.userID Contact:contact Finished:^(BOOL success, NSData *response) {
//        if (success) {
//            //请求成功
//            ChangeContactDetailResponse *resp = [ChangeContactDetailResponse parseFromData:response];
//            NSString *info = @"";
//            if (resp.isSucceed) {
//                //修改成功
//                _contact.contactRemark = remark;
//                [_contactView hiddenContactView];
//                [self updateAfterModify];
//                info = @"修改联系人备注成功";
//            }
//            else {
//                //修改失败
//                info = @"修改联系人备注失败";
//            }
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
//                                                            message:info
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"确定"
//                                                  otherButtonTitles:nil];
//            [alert show];
//        }
//        else {
//            //请求失败
//        }
//    }];
//}
//
////修改联系人成功后更新界面
//- (void)updateAfterModify {
//    //更新联系人到数据库
//    [LHLDBTools saveContact:[NSArray arrayWithObject:_contact] withFinished:nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:AddressNeedRefreshListNotification object:nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:ChatNeedRefreshListNotification object:nil];
//}
//
////加载联系人详细信息紧查看 并不保存至数据库
//- (void)setContactWithContact:(Contact *)newContact {
//    ContactModel *model = [[ContactModel alloc] init];
//    model.contactID = [NSString stringWithFormat:@"%d",newContact.contactId];
//    model.contactNickname = newContact.name;
//    model.contactRemark = newContact.customName;
//    model.contactIsBlocked = newContact.isBlocked;
//    model.contactPinyin = newContact.pinyin;
//    model.contactLastContactTime = newContact.lastContactTime;
//    model.contactSex = (ContactSex)newContact.gender;
//    model.contactRelationship = newContact.source;
//    model.contactIsProvider = newContact.isProvider;
//    model.contactLisence = newContact.lisence;
//    model.contactSignature = newContact.individualResume;
//    model.fuzhi = newContact.fuzhi;
//    //防止和列表头像不一致
//    model.contactAvatarURL = _contact.contactAvatarURL;
//    _contactDetail = model;
//}

#pragma mark - 菜单事件
//清除此人聊天记录  进行操作
- (IBAction)cleanUp:(id)sender {
    [LHLDBTools deleteChattingRecordsWithContactID:_ID withFinished:^(BOOL finish) {
        if (finish) {
            //从对话列表中删除
            [LHLDBTools deleteConversationWithID:_ID withFinished:^(BOOL finish) {
                if (finish) {
                    //更新对话界面
                    [[NSNotificationCenter defaultCenter] postNotificationName:ChatNeedRefreshListNotification object:nil];
                }
            }];
            //界面删除
            [_dataItems removeAllObjects];
            [_chatTableView reloadData];
        }
    }];
}

////屏蔽联系人 进行操作
//- (IBAction)hiddenUser:(id)sender {
//    FXAppDelegate *delegate = [FXAppDelegate shareFXAppDelegate];
//    [FXRequestDataFormat blockContactWithToken:delegate.token UserID:delegate.userID ContactID:[_ID intValue] IsBlocked:YES Finished:^(BOOL success, NSData *response) {
//        if (success) {
//            //请求成功
//            BlockContactResponse *resp = [BlockContactResponse parseFromData:response];
//            NSLog(@"屏蔽 %d",resp.isSucceed);
//            NSString *info = @"";
//            if (resp.isSucceed) {
//                //屏蔽成功
//                info = @"成功屏蔽此联系人，你可以在设置中取消屏蔽此人！";
//                _contact.contactIsBlocked = YES;
//                [LHLDBTools findContactWithContactID:_ID withFinished:^(ContactModel *model, NSString *error) {
//                    model.contactIsBlocked = YES;
//                    [LHLDBTools saveContact:[NSArray arrayWithObject:model] withFinished:^(BOOL finish) {
//                        [[NSNotificationCenter defaultCenter] postNotificationName:AddressNeedRefreshListNotification object:nil];
//                        [[NSNotificationCenter defaultCenter] postNotificationName:ChatNeedRefreshListNotification object:nil];
//                    }];
//                }];
//            }
//            else {
//                //屏蔽失败
//                info = @"屏蔽联系人失败！";
//            }
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
//                                                            message:info
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"确定"
//                                                  otherButtonTitles:nil];
//            [alert show];
//        }
//        else {
//            //请求失败
//        }
//    }];
//}

#pragma mark - 数据-

- (void)showChatMessage {
    [LHLDBTools getLatestChattingRecordsWithContactID:_ID withFinished:^(NSArray *list, NSString *error) {
        [_dataItems addObjectsFromArray:list];
        [_chatTableView reloadData];
        NSInteger indexCount = [_chatTableView numberOfRowsInSection:0];
        if (indexCount > 0) {
            //滚动到最后行
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:[_chatTableView numberOfRowsInSection:0] - 1 inSection:0];
            [_chatTableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }];
}

#pragma mark - 通知
//正在聊天时获取数据加在数组最后
- (void)addMessagesWhileChatting:(NSNotification *)notification {
    NSDictionary *dict = notification.userInfo;
    for (NSString *key in dict) {
        NSLog(@"key = %@,%d",key,[[dict objectForKey:key] count]);
    }
    BOOL hasMessage = NO;
    for (NSString *key in dict) {
        if ([key isEqualToString:_ID]) {
            //找到属于这个人得聊天记录
            NSArray *messages = [dict objectForKey:key];
            NSMutableArray *recordsForDB = [NSMutableArray array];
            for (int i = [messages count] - 1; i >= 0; i--) {
                Message *message = [messages objectAtIndex:i];
                //聊天记录对象
                MessageModel *model = [[MessageModel alloc] init];
                model.messageRecieverID = [NSString stringWithFormat:@"%d",message.contactId];
                model.messageSendTime = message.sendTime;
                model.messageContent = message.content;
                model.messageStatus = MessageStatusUnRead;
                model.messageShowTime = [NSNumber numberWithBool:YES];
                model.messageType = (ContentType)message.contentType;
                model.imageContent = message.binaryContent;
                [recordsForDB addObject:model];
                hasMessage = YES;
            }
            [_dataItems addObjectsFromArray:recordsForDB];
            break;
        }
    }
    if (hasMessage) {
        [_chatTableView reloadData];
        NSInteger indexCount = [_chatTableView numberOfRowsInSection:0];
        if (indexCount > 0 && hasMessage) {
            //滚动到最后行
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:[_chatTableView numberOfRowsInSection:0] - 1 inSection:0];
            [_chatTableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
        //删除未读标志
        [LHLDBTools clearUnreadStatusWithContactID:_ID withFinished:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:ChatNeedRefreshListNotification object:nil];
    }
}

- (void)writeIntoDBWithMessage:(Message *)message {
    __block NSMutableArray *lastCovs = nil;
    [LHLDBTools getConversationsWithFinished:^(NSMutableArray *covs,NSString *error) {
        lastCovs = covs;
    }];
    NSString *timeString = nil;
    //找到此联系人的最后聊天时间
    for (ConversationModel *cover in lastCovs) {
        if ([cover.conversationContactID isEqualToString:[NSString stringWithFormat:@"%d",message.contactId]]) {
            timeString = cover.conversationLastCommunicateTime;
            break;
        }
    }
    MessageModel *model = [[MessageModel alloc] init];
    model.messageRecieverID = [NSString stringWithFormat:@"%d",message.contactId];
    model.messageSendTime = message.sendTime;
    model.messageContent = message.content;
    model.messageStatus = MessageStatusDidSent;
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
    [LHLDBTools saveChattingRecord:[NSArray arrayWithObject:model] withFinished:nil];
    
    //最近对话表中加入此联系人
    ConversationModel *conv = [[ConversationModel alloc] init];
    conv.conversationContactID = [NSString stringWithFormat:@"%d",message.contactId];
    conv.conversationLastCommunicateTime = message.sendTime;
    if (message.contentType == Message_ContentTypeText) {
        conv.conversationLastChat = message.content;
    }
    else {
        conv.conversationLastChat = @"[图片]";
    }
    [LHLDBTools saveConversation:[NSArray arrayWithObject:conv] withFinished:nil];
    
    //更新联系人最后聊天时间
    [LHLDBTools getAllContactsWithFinished:^(NSArray *contactList, NSString *error) {
        for (ContactModel *contact in contactList) {
            if ([contact.contactID isEqualToString:[NSString stringWithFormat:@"%d",message.contactId]]) {
                contact.contactLastContactTime = message.sendTime;
                [LHLDBTools saveContact:[NSArray arrayWithObject:contact] withFinished:nil];
                break;
            }
        }
    }];
    
    //展示在界面中
    [_dataItems addObject:model];
    //对话列表更新界面
    [[NSNotificationCenter defaultCenter] postNotificationName:ChatNeedRefreshListNotification object:nil];
}

- (Message *)setMessage:(Message *)message withSendTime:(NSString *)time {
    Message *sendMessage = [[[[[[[[[Message builder]
                                   setUserId:message.userId]
                                  setContactId:message.contactId]
                                 setContentType:message.contentType]
                                setContent:message.content]
                               setSendTime:time]
                              setImageType:message.imageType]
                             setBinaryContent:message.binaryContent] build];
    return sendMessage;
}

#pragma mark - 下载聊天图片

- (void)downloadImage:(NSString *)content forCell:(FXMessageBoxCell *)cell {
    FXAppDelegate *delegate = [FXAppDelegate shareFXAppDelegate];
    NSString *urlString = [NSString stringWithFormat:@"%@&userId=%d&token=%@%@",content,delegate.userID,delegate.token,kSmallImage];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
//    [request setValidatesSecureCertificate:NO];
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request startAsynchronous];
    
    //保存到本地的图片名
    NSString *cacheString = [NSString stringWithFormat:@"%@%@",content,kSmallImage];
    
//    __weak ASIHTTPRequest *wRequest = request;
    [request setCompletionBlock:^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *imageData = [request responseData];
            [FXFileHelper documentSaveImageData:imageData withName:cacheString];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"下载完成！");
               [_chatTableView reloadData];
            });
        });
    }];
    [request setFailedBlock:^{
        //下载失败，保存NO到此命名的文件，防止重复下载
        NSLog(@"fail");
        NSData *data = [@"NO" dataUsingEncoding:NSUTF8StringEncoding];
        [FXFileHelper documentSaveImageData:data withName:cacheString withPathType:PathForChatImage];
    }];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FXMessageBoxCell *cell = [tableView dequeueReusableCellWithIdentifier:MessageCellIdentifier forIndexPath:indexPath];
    MessageModel *message = [_dataItems objectAtIndex:indexPath.row];
    cell.delegate = self;
    if (message.messageStatus <=2) {
        //发送
        cell.cellStyle = MessageCellStyleSender;
        cell.userPhotoView.image = _userImage;
    }
    else {
        //接收
        cell.cellStyle = MessageCellStyleReceive;
        if ([FXFileHelper isHeadImageExist:_contact.contactAvatarURL]) {
            NSData *imageData = [FXFileHelper headImageWithName:_contact.contactAvatarURL];
            cell.userPhotoView.image = [UIImage imageWithData:imageData];
        }
        else {
            cell.userPhotoView.image = [UIImage imageNamed:@"placeholder.png"];
        }
    }
    cell.showTime = [message.messageShowTime boolValue];
    if (cell.showTime) {
        cell.timeLabel.text = [FXTimeFormat setTimeFormatWithString:message.messageSendTime];
    }
    if (message.messageType == ContentTypeText) {
        //文字消息
        [cell setContents:message.messageContent];
    }
    else {
        //图片消息
        cell.contents = nil;
        if (message.messageStatus <= 2) {
            //发送的图片保存在数据库中
            [cell setImageData:message.imageContent];
        }
        else {
            //接收的图片保存在文件中
            cell.imageURL = message.messageContent;
            NSString *cacheString = [NSString stringWithFormat:@"%@%@",message.messageContent,kSmallImage];
            NSData *imageData = [FXFileHelper chatImageAlreadyLoadWithName:cacheString];
            if (imageData) {
                //已保存此图
                if ([imageData length] < 3 && [[[NSString alloc] initWithData:imageData encoding:NSUTF8StringEncoding] isEqualToString:@"NO"]) {
                    [cell setNullView];
                }
                else {
                    UIView *view = [FXTextFormat getContentViewWithImageData:imageData];
                    if (!view) {
                        [cell setNullView];
                    }
                    else {
                        [cell setImageData:imageData];
                    }
                }
            }
            else {
                //未保存此图
                [self downloadImage:message.messageContent forCell:cell];
                [cell setNullView];
            }
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageModel *model = [_dataItems objectAtIndex:indexPath.row];
    if (model.messageType == ContentTypeText) {
        UIView *view = [FXTextFormat getContentViewWithMessage:model.messageContent];
        CGFloat height = view.frame.size.height;
        return height + kTimeLabelHeight < 44 ? 64 : height + kTimeLabelHeight + 20;
    }
    else {
        if (model.messageStatus <= 2) {
            UIView *view = [FXTextFormat getContentViewWithImageData:model.imageContent];
            return view.frame.size.height + kTimeLabelHeight + 20;
        }
        else {
            //接收的图片保存在文件中
//            NSValue *value = [_plist objectForKey:model.messageContent];
//            if (value) {
//                //已缓存此图
//                CGSize imageSize = [value CGSizeValue];
//                NSLog(@"imageSize = %@",NSStringFromCGSize(imageSize));
//                if (imageSize.height == 0 && imageSize.width == 0) {
//                    //下载失败
//                    return 100 + kTimeLabelHeight + 20;
//                }
//                else {
//                    return imageSize.height + kTimeLabelHeight + 20;
//                }
//            }
//            else {
//                //未缓存此图
//                NSLog(@"!!!!!");
//                return 100 + kTimeLabelHeight + 20;
//            }
//        }
            NSString *cacheString = [NSString stringWithFormat:@"%@%@",model.messageContent,kSmallImage];
            NSData *imageData = [FXFileHelper chatImageAlreadyLoadWithName:cacheString];
            NSLog(@"length = %d",[imageData length]);
            if (imageData) {
                //已保存此图
                if ([imageData length] < 3 && [[[NSString alloc] initWithData:imageData encoding:NSUTF8StringEncoding] isEqualToString:@"NO"]) {
                    return 100 + kTimeLabelHeight + 20;
                }
                else {
                    UIView *view = [FXTextFormat getContentViewWithImageData:imageData];
                    if (!view) {
                        return 80 + kTimeLabelHeight;
                    }
                    return view.frame.size.height + kTimeLabelHeight + 20;
                }
            }
            else {
                //未保存此图
                return 100 + kTimeLabelHeight + 20;
            }
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self hiddenBottomView];
}

#pragma mark - 获取发送信息和键盘代理 
#pragma mark - GetInputTextDelegate
- (void)getInputText:(NSString *)intputText {
    if ([intputText length] <= 0) {
        return;
    }
    if ([intputText length] > 300) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"输入超过300字符上限,请分次发送！"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    FXAppDelegate *delegate = [FXAppDelegate shareFXAppDelegate];
    Message *sendMessage = [[[[[[[Message builder]
                                 setUserId:delegate.userID]
                                setContactId:[_ID intValue]]
                               setContentType:Message_ContentTypeText]
                              setContent:intputText]
                             setSendTime:nil] build];
    [self sendMessageWithMessage:sendMessage];
    _inputView.inputView.text = @"";
}

- (void)sendMessageWithMessage:(Message *)message {
    [_infoView show];
    [_infoView setText:@"正在发送消息"];
    FXAppDelegate *delegate = [FXAppDelegate shareFXAppDelegate];
    [FXRequestDataFormat sendMessageWithToken:delegate.token UserID:delegate.userID Message:message Finished:^(BOOL success, NSData *response) {
        if (success) {
            //请求成功
            SendMessageResponse *resp = [SendMessageResponse parseFromData:response];
            if (resp.isSucceed) {
                //成功发送
                //写入数据库并保存数组
                Message *sendMessage = [self setMessage:message withSendTime:resp.sendTime];
                [self writeIntoDBWithMessage:sendMessage];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[_dataItems count] - 1 inSection:0];
                NSArray *message = [NSArray arrayWithObject:indexPath];
                [self.chatTableView insertRowsAtIndexPaths:message withRowAnimation:UITableViewRowAnimationBottom];
                [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                [_infoView setText:@"消息发送成功！"];
            }
            else {
                NSLog(@"errorCode = %d",resp.errorCode);
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示信息"
//                                                                    message:@"消息发送失败"
//                                                                   delegate:nil
//                                                          cancelButtonTitle:@"确定"
//                                                          otherButtonTitles:nil];
//                [alertView show];
                [_infoView setText:@"消息发送失败！"];
            }
        }
        else {
            [_infoView setText:@"网络请求超时！"];
        }
        [_infoView hide];
    }];
}

#pragma mark - 键盘适应

- (void)sendActionWithButtonTag:(PictureTags)tag {
    [self adjustViewWithKeyboardWithTag:tag];
    switch (tag) {
        case PictureEmoji: {
            NSLog(@"Emoji!");
        }
            break;
        case PicturePhoto: {
            NSLog(@"Picture!");
        }
            break;
        default:
            break;
    }
}

- (void)adjustViewWithKeyboardWithTag:(PictureTags)tag {
    switch (tag) {
        case PicturePhoto: {
            if (!_showListView) {
                //若没有弹出表情框
                _showListView = YES;
                if (_showKeyBoard) {
                    [_inputView.inputView resignFirstResponder];
                }
                else {
                    if (_showEmojiView) {
                        _showEmojiView = NO;
                        [FXKeyboardAnimation moveView:_emojiListView withOffset:_emojiListView.bounds.size.height];
                    }
                    else {
                        //若没有弹出键盘、表情框、图片框
                        [FXKeyboardAnimation moveView:_inputView withOffset:-_pictureListView.bounds.size.height];
                    }
                    [FXKeyboardAnimation moveView:_pictureListView withOffset:-_pictureListView.bounds.size.height];
                }
            }
        }
            break;
        case PictureEmoji: {
            if (!_showEmojiView) {
                //若没有弹出表情框
                _showEmojiView = YES;
                if (_showKeyBoard) {
                    [_inputView.inputView resignFirstResponder];
                }
                else {
                    if (_showListView) {
                        _showListView = NO;
                        [FXKeyboardAnimation moveView:_pictureListView withOffset:_pictureListView.bounds.size.height];
                    }
                    else {
                        //若没有弹出键盘、表情框、图片框
                        [FXKeyboardAnimation moveView:_inputView withOffset:-_emojiListView.bounds.size.height];
                    }
                    [FXKeyboardAnimation moveView:_emojiListView withOffset:-_emojiListView.bounds.size.height];
                }
            }
        }
            break;
        default:
            break;
    }
}

- (void)keyboardWillChangeWithInfo:(NSDictionary *)info {
    CGRect beginRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat offset = 0;
    if (endRect.origin.y >= kScreenHeight) {
        //键盘收回
        _showKeyBoard = NO;
        if (_showListView || _showEmojiView) {
            if (_showListView) {
                //若弹出图片框，则计算图片框与键盘高度差
                offset = endRect.size.height - _pictureListView.bounds.size.height;
                [FXKeyboardAnimation moveView:_pictureListView withOffset:-_pictureListView.bounds.size.height];
            }
            if (_showEmojiView) {
                //若弹出表情框，则计算表情框与键盘高度差
                offset = endRect.size.height - _emojiListView.bounds.size.height;
                [FXKeyboardAnimation moveView:_emojiListView withOffset:-_emojiListView.bounds.size.height];
            }
        }
        else {
            //键盘收回
            offset = endRect.size.height;
        }
    }
    else {
        //键盘出现
        _showKeyBoard = YES;
        if (_showListView) {
            //若此时已经弹出图片框
            offset = _pictureListView.bounds.size.height - endRect.size.height;
            //隐藏图片框
            [FXKeyboardAnimation moveView:_pictureListView withOffset:_pictureListView.bounds.size.height];
            _showListView = NO;
            _keyboardHeight = endRect.size.height;
        }
        else if (_showEmojiView) {
            //若此时已经弹出表情框
            offset = _emojiListView.bounds.size.height - endRect.size.height;
            //隐藏表情框
            [FXKeyboardAnimation moveView:_emojiListView withOffset:_emojiListView.bounds.size.height];
            _showEmojiView = NO;
            _keyboardHeight = endRect.size.height;
        }
        else {
            //未弹出表情框
            if (beginRect.size.height == endRect.size.height && beginRect.origin.y == kScreenHeight) {
                //键盘弹出
                offset = -beginRect.size.height;
                _keyboardHeight = endRect.size.height;
            }
            else {
                //键盘高度改变
                offset = _keyboardHeight - endRect.size.height;
                _keyboardHeight = endRect.size.height;
            }
        }
    }
    [FXKeyboardAnimation moveView:_inputView withOffset:offset];
}

- (void)hiddenBottomView {
    if (_showKeyBoard || _showListView || _showEmojiView) {
        [_inputView.inputView becomeFirstResponder];
        [_inputView.inputView resignFirstResponder];
    }
}

#pragma mark - 图片菜单代理
#pragma mark - PictureButtonDelegate

- (void)pictureButtonFunctionWithTag:(ButtonTags)tag {
    NSInteger sourceType = UIImagePickerControllerSourceTypeCamera;
    switch (tag) {
        case ButtonTagePicture: {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSLog(@"本地相册！");
        }
            break;
        case ButtonTagPhoto: {
            sourceType = UIImagePickerControllerSourceTypeCamera;
            NSLog(@"拍照！");
        }
            break;
        default:
            break;
    }
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.sourceType = sourceType;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}

#pragma mark - UIImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *imageData = UIImageJPEGRepresentation(originImage, 0.5);
    FXAppDelegate *delegate = [FXAppDelegate shareFXAppDelegate];
    Message *sendMessage = [[[[[[[[[Message builder]
                                   setUserId:delegate.userID]
                                  setContactId:[_ID intValue]]
                                 setContentType:Message_ContentTypeImage]
                                setContent:nil]
                               setSendTime:nil]
                              setImageType:Message_ImageTypeJpg]
                             setBinaryContent:imageData] build];
    [self sendMessageWithMessage:sendMessage];
    if (_showListView) {
        _showListView = NO;
        [FXKeyboardAnimation moveView:_inputView withHeight:kScreenHeight - 64 - kInputViewHeight];
        [FXKeyboardAnimation moveView:_pictureListView withHeight:kScreenHeight - 64];
    }
}

#pragma mark - EmojiDelegate

- (void)touchEmojiButton:(UIButton *)sender {
    if ((sender.tag + 1) % 21 == 0) {
        //删除按钮
        if ([_inputView.inputView.text length] > 0) {
            _inputView.inputView.text = [_inputView.inputView.text substringToIndex:[_inputView.inputView.text length] - 1];
        }
    }
    else {
        int index = sender.tag + 1;
        if (sender.tag + 1 > 21) {
            //减去一个删除按钮
            index = sender.tag;
        }
        NSDictionary *list = [FXTextFormat getEmojiList];
        NSString *key = [NSString stringWithFormat:@"%d",index];
        NSString *emoji = [NSString stringWithFormat:@"[#%@]",[list objectForKey:key]];
        _inputView.inputView.text = [_inputView.inputView.text stringByAppendingString:emoji];
    }
    NSInteger length = [_inputView.inputView.text length];
    [_inputView.inputView scrollRangeToVisible:NSMakeRange(length, 1)];
}

- (void)sendMessage {
    [self getInputText:_inputView.inputView.text];
    [self hiddenBottomView];
}

#pragma mark - cell delegate

- (void)touchContact:(UIGestureRecognizer *)tap {
//    [self addDetailView];
    if (_isFromDetail) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        FXContactDetailController *contactC = [[FXContactDetailController alloc] init];
        contactC.contact = _contact;
        contactC.ID = _contact.contactID;
        contactC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:contactC animated:YES];
    }
}

- (void)loadLargeImageWithURL:(NSString *)urlString {
    FXDetailImageView *bigView = [[FXDetailImageView alloc] initWithFrame:CGRectMake(0, 0, 320, kScreenHeight)];
    [self.view.window addSubview:bigView];
    FXAppDelegate *delegate = [FXAppDelegate shareFXAppDelegate];
    NSString *url = [NSString stringWithFormat:@"%@&userId=%d&token=%@",urlString,delegate.userID,delegate.token];
    
    if ([FXFileHelper chatImageAlreadyLoadWithName:urlString]) {
        [bigView setBigImageWithData:[FXFileHelper chatImageAlreadyLoadWithName:urlString]];
    }
    else {
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
        [request setRequestMethod:@"POST"];
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
//        [request setValidatesSecureCertificate:NO];
        [request setDefaultResponseEncoding:NSUTF8StringEncoding];
        [request startAsynchronous];
        
        __block long long dataLength = 0;
        [request setHeadersReceivedBlock:^(NSDictionary *headers) {
            dataLength = [[headers objectForKey:@"Content-Length"] longLongValue];
        }];
        
        __block NSMutableData *allData = [[NSMutableData alloc] init];
        [request setDataReceivedBlock:^(NSData *data) {
            [allData appendData:data];
            [bigView.progressView setProgress:(double)[allData length] / dataLength animated:YES];
        }];
        [request setCompletionBlock:^{
            [bigView setBigImageWithData:allData];
            [FXFileHelper documentSaveImageData:allData withName:urlString withPathType:PathForChatImage];
        }];
    }
}

- (void)loadLargeImageWithData:(NSData *)data {
    FXDetailImageView *bigView = [[FXDetailImageView alloc] initWithFrame:CGRectMake(0, 0, 320, kScreenHeight)];
    [self.view.window addSubview:bigView];
    [bigView setBigImageWithData:data];
}

@end
