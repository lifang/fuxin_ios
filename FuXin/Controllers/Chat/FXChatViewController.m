//
//  FXChatViewController.m
//  FuXin
//
//  Created by 徐宝桥 on 14-5-20.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXChatViewController.h"
#import "KxMenu.h"
#import "FXChatInputView.h"
#import "FXMessageBoxCell.h"
#import "FXKeyboardAnimation.h"

static NSString *MessageIdentifier = @"messageIdentifier";

@interface FXChatViewController ()<GetInputTextDelegate>

@property (nonatomic, strong) FXChatInputView *inputView;

//若键盘出现view上移则YES，若不上移为NO
@property (nonatomic, assign) BOOL needResetView;

@property (nonatomic, assign) BOOL needResetInputView;

@end

@implementation FXChatViewController

@synthesize inputView = _inputView;

@synthesize chatTableView = _chatTableView;
@synthesize dataItems = _dataItems;
@synthesize needResetView = _needResetView;
@synthesize needResetInputView = _needResetInputView;

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
    self.title = @"聊天";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setLeftNavBarItem];
    [self setRightNavBarItem];
    [self initUI];
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
    [_chatTableView registerClass:[FXMessageBoxCell class] forCellReuseIdentifier:MessageIdentifier];
    [self.view addSubview:_chatTableView];
    //清除多余划线
    [self hiddenExtraCellLine];
    
    _inputView = [[FXChatInputView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 64 - kInputViewHeight, 320, kInputViewHeight)];
    _inputView.inputDelegate = self;
    [self.view addSubview:_inputView];
    
    _dataItems = [[NSMutableArray alloc] init];
}

- (void)hiddenExtraCellLine {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [_chatTableView setTableFooterView:view];
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

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FXMessageBoxCell *cell = [tableView dequeueReusableCellWithIdentifier:MessageIdentifier forIndexPath:indexPath];
    cell.cellStyle = indexPath.row % 2 == 0 ? MessageCellStyleSender : MessageCellStyleReceive;
    [cell setContents:[_dataItems objectAtIndex:indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *text = [_dataItems objectAtIndex:indexPath.row];
    CGFloat height = [text sizeWithFont:[UIFont systemFontOfSize:14]
                      constrainedToSize:CGSizeMake(kMessageBoxWigthMax, CGFLOAT_MAX)
                          lineBreakMode:NSLineBreakByWordWrapping].height;
    return height < 44 ? 64 : height + 20;
}

#pragma mark - 获取发送信息和键盘代理
- (void)getInputText:(NSString *)intputText {
    [_dataItems addObject:intputText];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[_dataItems count] - 1 inSection:0];
    NSArray *message = [NSArray arrayWithObject:indexPath];
    [self.chatTableView insertRowsAtIndexPaths:message withRowAnimation:UITableViewRowAnimationBottom];
    [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//    [self.chatTableView reloadData];
}

//键盘事件
- (void)viewNeedMoveUpWithKeyboardHeight:(CGFloat)height {
    if ([_dataItems count] > 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[_dataItems count] - 1 inSection:0];
        UITableViewCell *cell = [self.chatTableView cellForRowAtIndexPath:indexPath];
        CGFloat dy = kScreenHeight - 64 - cell.frame.origin.y - cell.frame.size.height;
        if (dy > height) {
            _needResetView = NO;
        }
        else {
            _needResetView = YES;
            [FXKeyboardAnimation moveUpView:self.view withOffset:height];
        }
    }
    else {
        _needResetView = YES;
        [FXKeyboardAnimation moveUpView:self.view withOffset:height];
    }
    if (!_needResetView) {
        _needResetInputView = YES;
        [FXKeyboardAnimation moveUpView:_inputView withOffset:height];
    }
}

- (void)viewNeedMoveResetWithKeyBoardHeight:(CGFloat)height {
    if (_needResetInputView) {
        _needResetInputView = NO;
        [FXKeyboardAnimation resetView:_inputView withOffset:height];
    }
    if (_needResetView) {
        _needResetView = NO;
        [FXKeyboardAnimation resetView:self.view withOffset:height];
    }
}

@end
