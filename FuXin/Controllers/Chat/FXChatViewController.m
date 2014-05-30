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
@synthesize emojiListView = _emojiListView;
@synthesize lastShowDate = _lastShowDate;


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
    self.title = _contact.contactNickname;
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

- (void)viewDidDisappear:(BOOL)animated {
    //注销掉键盘通知
    [[NSNotificationCenter defaultCenter] removeObserver:_inputView];
}

#pragma mark - UI

- (void)initUI {
    _chatTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, kScreenHeight - 64 - kInputViewHeight) style:UITableViewStylePlain];
    _chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _chatTableView.delegate = self;
    _chatTableView.dataSource = self;
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

#pragma mark - 菜单事件
//清除此人聊天记录  进行操作
- (IBAction)cleanUp:(id)sender {
    
}

//屏蔽联系人 进行操作
- (IBAction)hiddenUser:(id)sender {
    
}

#pragma mark - 数据

- (void)showChatMessage {
    [LHLDBTools clearUnreadStatusWithContactID:_contact.contactID withFinished:^(BOOL finish) {
        
    }];
    [LHLDBTools getLatestChattingRecordsWithContactID:_contact.contactID withFinished:^(NSArray *list, NSString *error) {
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
    //展示在界面中
    [_dataItems addObject:model];
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
    CGFloat height = [model.messageContent sizeWithFont:[UIFont systemFontOfSize:14]
                      constrainedToSize:CGSizeMake(kMessageBoxWigthMax, CGFLOAT_MAX)
                          lineBreakMode:NSLineBreakByWordWrapping].height;

    return height + kTimeLabelHeight < 44 ? 64 : height + kTimeLabelHeight + 20;
}

#pragma mark - 获取发送信息和键盘代理 
#pragma mark - GetInputTextDelegate
- (void)getInputText:(NSString *)intputText {
    FXAppDelegate *delegate = [FXAppDelegate shareFXAppDelegate];
    Message *sendMessage = [[[[[[Message builder] setUserId:delegate.userID] setContactId:[_contact.contactID intValue]] setContent:intputText] setSendTime:nil] build];
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
    _inputView.inputView.text = [_inputView.inputView.text stringByAppendingString:sender.titleLabel.text];
}

@end
