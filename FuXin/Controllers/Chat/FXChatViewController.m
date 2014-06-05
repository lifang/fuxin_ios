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

static NSString *MessageCellIdentifier = @"MCI";

@interface FXChatViewController ()<GetInputTextDelegate,PictureButtonDelegate,EmojiDelegate>

@property (nonatomic, strong) FXChatInputView *inputView;

@property (nonatomic, assign) BOOL showListView;

@property (nonatomic, assign) BOOL showEmojiView;

@property (nonatomic, assign) BOOL showKeyBoard;

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
@synthesize lastShowDate = _lastShowDate;
@synthesize contactView = _contactView;
@synthesize refreshControl = _refreshControl;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [FXAppDelegate shareFXAppDelegate].attributedTitleLabel.text = _contact.contactNickname;
}

- (void)viewDidDisappear:(BOOL)animated {
    //注销掉键盘通知
    [[NSNotificationCenter defaultCenter] removeObserver:_inputView];
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
    _lastShowDate = [NSDate date];
    
    [self initPictureListView];
    [self initEmojiView];
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

//联系人详细
- (void)addDetailView {
    if (!_contactView) {
        _contactView = [[FXContactView alloc] initWithFrame:CGRectMake(0, 0, 320, kScreenHeight - 64)];
        _contactView.contact = _contact;
        [self.view addSubview:_contactView];
    }
    if (_contactView.hidden) {
        _contactView.hidden = NO;
        _contactView.alpha = 1.0f;
    }
}

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

//重写导航右按钮方法
- (IBAction)rightBarTouched:(id)sender {
    NSArray *listArray = [NSArray arrayWithObjects:
                          [KxMenuItem menuItem:@"清除聊天记录"
                                         image:nil
                                        target:self
                                        action:@selector(cleanUp:)],
                          [KxMenuItem menuItem:@"屏蔽此人"
                                         image:nil
                                        target:self action:@selector(hiddenUser:)],
                          nil];
    CGRect rect = CGRectMake(280, 0, 20, 0);
    [KxMenu showMenuInView:self.view fromRect:rect menuItems:listArray];
}

#pragma mark - 修改联系人

- (void)modifyContactRemark:(NSString *)remark {
    Contact *contact = [[[[[[[[[[[[[[Contact builder]
                                    setContactId:[_contact.contactID intValue]]
                                   setName:_contact.contactNickname]
                                  setCustomName:remark]
                                 setPinyin:_contact.contactPinyin]
                                setIsBlocked:_contact.contactIsBlocked]
                               setLastContactTime:_contact.contactLastContactTime]
                              setGender:(Contact_GenderType)_contact.contactSex]
                             setSource:_contact.contactRelationship]
                            setTileUrl:_contact.contactAvatarURL]
                           setIsProvider:_contact.contactIsProvider]
                          setLisence:_contact.contactLisence]
                         setIndividualResume:_contact.contactSignature] build];
    FXAppDelegate *delegate = [FXAppDelegate shareFXAppDelegate];
    [FXRequestDataFormat modifyContactDetailWithToken:delegate.token UserID:delegate.userID Contact:contact Finished:^(BOOL success, NSData *response) {
        if (success) {
            //请求成功
            ChangeContactDetailResponse *resp = [ChangeContactDetailResponse parseFromData:response];
            if (resp.isSucceed) {
                //修改成功
                NSLog(@"修改联系人成功");
                [_contactView hiddenContactView];
            }
            else {
                //修改失败
                NSLog(@"修改联系人失败");
            }
        }
        else {
            //请求失败
        }
    }];
}

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

//屏蔽联系人 进行操作
- (IBAction)hiddenUser:(id)sender {
    FXAppDelegate *delegate = [FXAppDelegate shareFXAppDelegate];
    [FXRequestDataFormat blockContactWithToken:delegate.token UserID:delegate.userID ContactID:[_ID intValue] IsBlocked:YES Finished:^(BOOL success, NSData *response) {
        if (success) {
            //请求成功
            BlockContactResponse *resp = [BlockContactResponse parseFromData:response];
            if (resp.isSucceed) {
                //屏蔽成功
            }
            else {
                //屏蔽失败
            }
        }
        else {
            //请求失败
        }
    }];
}

#pragma mark - 数据

- (void)showChatMessage {
    [LHLDBTools clearUnreadStatusWithContactID:_ID withFinished:^(BOOL finish) {
        
    }];
    [LHLDBTools getLatestChattingRecordsWithContactID:_ID withFinished:^(NSArray *list, NSString *error) {
        [_dataItems addObjectsFromArray:list];
        [_chatTableView reloadData];
        int indexCount = [_chatTableView numberOfRowsInSection:0];
        if (indexCount > 0) {
            //滚动到最后行
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:[_chatTableView numberOfRowsInSection:0] - 1 inSection:0];
            [_chatTableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }];
}

- (void)writeIntoDBWithMessage:(Message *)message {
    MessageModel *model = [[MessageModel alloc] init];
    model.messageRecieverID = [NSString stringWithFormat:@"%d",message.contactId];
    model.messageSendTime = [FXTimeFormat nowDateString];
    model.messageContent = message.content;
    model.messageStatus = MessageStatusDidSent;
    model.messageShowTime = [NSNumber numberWithBool:[self needShowDate]];
    [LHLDBTools saveChattingRecord:[NSArray arrayWithObject:model] withFinished:^(BOOL finish) {
        
    }];
    //最近对话表中加入此联系人
    ConversationModel *conv = [[ConversationModel alloc] init];
    conv.conversationContactID = [NSString stringWithFormat:@"%d",message.contactId];
    conv.conversationLastCommunicateTime = [FXTimeFormat nowDateString];
    conv.conversationLastChat = message.content;
    [LHLDBTools saveConversation:[NSArray arrayWithObject:conv] withFinished:^(BOOL finish) {
        
    }];
    //展示在界面中
    [_dataItems addObject:model];
    //对话列表更新界面
    [[NSNotificationCenter defaultCenter] postNotificationName:ChatNeedRefreshListNotification object:nil];
}

- (BOOL)needShowDate {
    NSDate *now = [NSDate date];
    double diff = [now timeIntervalSinceDate:_lastShowDate];
    if (diff > kTimeInterval) {
        _lastShowDate = now;
        return YES;
    }
    return NO;
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
    if (message.messageStatus <=2) {
        //发送
        cell.cellStyle = MessageCellStyleSender;
    }
    else {
        //接收
        cell.cellStyle = MessageCellStyleReceive;
    }
    cell.showTime = [message.messageShowTime boolValue];
    if (cell.showTime) {
        cell.timeLabel.text = [FXTimeFormat setTimeFormatWithString:message.messageSendTime];
    }
    [cell setContents:message.messageContent];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageModel *model = [_dataItems objectAtIndex:indexPath.row];
    UIView *view = [FXTextFormat getContentViewWithMessage:model.messageContent];
    CGFloat height = view.frame.size.height;
    return height + kTimeLabelHeight < 44 ? 64 : height + kTimeLabelHeight + 20;
}

#pragma mark - 获取发送信息和键盘代理 
#pragma mark - GetInputTextDelegate
- (void)getInputText:(NSString *)intputText {
    FXAppDelegate *delegate = [FXAppDelegate shareFXAppDelegate];
    Message *sendMessage = [[[[[[Message builder] setUserId:delegate.userID] setContactId:[_ID intValue]] setContent:intputText] setSendTime:nil] build];
    [FXRequestDataFormat sendMessageWithToken:delegate.token UserID:delegate.userID Message:sendMessage Finished:^(BOOL success, NSData *response) {
        if (success) {
            //请求成功
            SendMessageResponse *resp = [SendMessageResponse parseFromData:response];
            if (resp.isSucceed) {
                //成功发送
                //写入数据库并保存数组
                [self writeIntoDBWithMessage:sendMessage];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[_dataItems count] - 1 inSection:0];
                NSArray *message = [NSArray arrayWithObject:indexPath];
                [self.chatTableView insertRowsAtIndexPaths:message withRowAnimation:UITableViewRowAnimationBottom];
                [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
            else {
                NSLog(@"errorCode = %d",resp.errorCode);
            }
        }
    }];
}

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
        }
        else if (_showEmojiView) {
            //若此时已经弹出表情框
            offset = _emojiListView.bounds.size.height - endRect.size.height;
            //隐藏表情框
            [FXKeyboardAnimation moveView:_emojiListView withOffset:_emojiListView.bounds.size.height];
            _showEmojiView = NO;
        }
        else {
            //未弹出表情框
            if (beginRect.size.height == endRect.size.height) {
                //键盘弹出
                offset = -beginRect.size.height;
            }
            else {
                //键盘高度改变
                offset = beginRect.size.height - endRect.size.height;
            }
        }
    }
    [FXKeyboardAnimation moveView:_inputView withOffset:offset];
}

#pragma mark - 图片菜单代理
#pragma mark - PictureButtonDelegate

- (void)pictureButtonFunctionWithTag:(ButtonTags)tag {
    switch (tag) {
        case ButtonTagePicture: {
            NSLog(@"本地相册！");
        }
            break;
        case ButtonTagPhoto: {
            NSLog(@"拍照！");
        }
            break;
        default:
            break;
    }
}

#pragma mark - EmojiDelegate

- (void)touchEmojiButton:(UIButton *)sender {
    NSString *emoji = [NSString stringWithFormat:@"[#%d]",sender.tag + 1];
    _inputView.inputView.text = [_inputView.inputView.text stringByAppendingString:emoji];
}

@end
