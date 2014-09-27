//
//  FXAllMessageController.m
//  FuXin
//
//  Created by 徐宝桥 on 14-9-22.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXAllMessageController.h"
#import "FXHistoryCell.h"

#define kSmallImageSize   @"&width=216&height=144"

@interface FXAllMessageController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIButton *leftButton;

@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, strong) UILabel *currentLabel;

@property (nonatomic, strong) UILabel *totalLabel;

@property (nonatomic, assign) int currentIndex;

@property (nonatomic, assign) int totalIndex;

@property (nonatomic, strong) NSMutableArray *dataItems;

@property (nonatomic, strong) NSMutableDictionary *systemDict;

@end

@implementation FXAllMessageController

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
    self.title = @"所有消息";
    [self setLeftNavBarItemWithImageName:@"back.png"];
    _systemDict = [[NSMutableDictionary alloc] init];
    _dataItems = [[NSMutableArray alloc] init];
    _currentIndex = 1;
    _totalIndex = 1;
    [self initUI];
    [self downloadDataWithPage:_currentIndex];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI {
    _historyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, kScreenHeight - 64 - 49)];
    _historyTableView.delegate = self;
    _historyTableView.dataSource = self;
    _historyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_historyTableView];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, kScreenHeight - 64 - 49, 320, 49)];
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftButton.frame = CGRectMake(78, 9, 32, 32);
    [_leftButton setBackgroundImage:[UIImage imageNamed:@"left_normal.png"] forState:UIControlStateNormal];
    [_leftButton setBackgroundImage:[UIImage imageNamed:@"left_selected.png"] forState:UIControlStateHighlighted];
    [_leftButton setBackgroundImage:[UIImage imageNamed:@"left_unable.png"] forState:UIControlStateDisabled];
    [_leftButton addTarget:self action:@selector(pervious:) forControlEvents:UIControlEventTouchUpInside];
    [toolbar addSubview:_leftButton];
    
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton.frame = CGRectMake(210, 9, 32, 32);
    [_rightButton setBackgroundImage:[UIImage imageNamed:@"right_normal.png"] forState:UIControlStateNormal];
    [_rightButton setBackgroundImage:[UIImage imageNamed:@"right_selected.png"] forState:UIControlStateHighlighted];
    [_rightButton setBackgroundImage:[UIImage imageNamed:@"right_unable.png"] forState:UIControlStateDisabled];
    [_rightButton addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    [toolbar addSubview:_rightButton];
    
    _currentLabel = [[UILabel alloc] initWithFrame:CGRectMake(111, 15, 46, 20)];
    _currentLabel.backgroundColor = [UIColor clearColor];
    _currentLabel.textColor = [UIColor redColor];
    _currentLabel.font = [UIFont systemFontOfSize:14];
    _currentLabel.textAlignment = NSTextAlignmentRight;
    _currentLabel.text = [NSString stringWithFormat:@"%d",_currentIndex];
    [toolbar addSubview:_currentLabel];
    
    _totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(163, 15, 46, 20)];
    _totalLabel.backgroundColor = [UIColor clearColor];
    _totalLabel.font = [UIFont systemFontOfSize:14];
    _totalLabel.text = [NSString stringWithFormat:@"%d",_totalIndex];
    [toolbar addSubview:_totalLabel];
    
    UILabel *spaceLabel = [[UILabel alloc] initWithFrame:CGRectMake(158, 15, 4, 20)];
    spaceLabel.backgroundColor = [UIColor clearColor];
    spaceLabel.font = [UIFont systemFontOfSize:14];
    spaceLabel.text = @"/";
    [toolbar addSubview:spaceLabel];
    [self.view addSubview:toolbar];
}

- (void)downloadDataWithPage:(int)page {
    FXAppDelegate *delegate = [FXAppDelegate shareFXAppDelegate];
    [FXRequestDataFormat messageHistoryWithToken:delegate.token UserID:delegate.userID ContactID:[_contact.contactID intValue] PageIndex:page PageSize:kPageSize Finished:^(BOOL success, NSData *response) {
        MessageHistoryResponse *resp = [MessageHistoryResponse parseFromData:response];
        NSLog(@"%d,%d",success,resp.pageCount);
        _totalIndex = resp.pageCount;
        _totalLabel.text = [NSString stringWithFormat:@"%d",_totalIndex];
        [_dataItems removeAllObjects];
        for (MessageList *list in resp.messageListsList) {
            for (Message *message in list.messagesList) {
                [_dataItems addObject:message];
            }
        }
        [_historyTableView reloadData];
        if (_currentIndex >= _totalIndex) {
            _rightButton.enabled = NO;
        }
        else {
            _rightButton.enabled = YES;
        }
        if (_currentIndex <= 1) {
            _leftButton.enabled = NO;
        }
        else {
            _leftButton.enabled = YES;
        }
    }];
}

#pragma mark - Action

- (IBAction)pervious:(id)sender {
    if (_currentIndex <= 1) {
        return;
    }
    _currentIndex --;
    _currentLabel.text = [NSString stringWithFormat:@"%d",_currentIndex];
    [self downloadDataWithPage:_currentIndex];
}

- (IBAction)next:(id)sender {
    if (_currentIndex >= _totalIndex) {
        return;
    }
    _currentIndex ++;
    _currentLabel.text = [NSString stringWithFormat:@"%d",_currentIndex];
    [self downloadDataWithPage:_currentIndex];
}


#pragma mark - UITableView 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"History";
    FXHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[FXHistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    Message *message = [_dataItems objectAtIndex:indexPath.row];

    [cell setName:_contact.contactNickname userID:message.contactId];
    [cell setTime:message.sendTime];
    if (message.contentType == Message_ContentTypeText) {
        //文字消息
        [cell setContents:message.content];
    }
    else if (message.contentType == Message_ContentTypeImage){
        //图片消息
        //接收的图片保存在文件中
        cell.imageURL = message.content;
        NSString *cacheString = [NSString stringWithFormat:@"%@%@",message.content,kSmallImageSize];
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
            [self downloadImage:message.content forCell:cell];
            [cell setNullView];
        }

    }
    else {
        //通知消息
        if (!cell.messageView) {
            cell.messageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMessageBoxWidthMax, 1)];
            UIWebView *webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kMessageBoxWidthMax, 1)];
            webview.delegate = self;
            webview.tag = 100;
            webview.scrollView.scrollEnabled = NO;
            webview.opaque = NO;
            webview.backgroundColor = [UIColor clearColor];
            [cell.messageView addSubview:webview];
        }
        UIWebView *webView = (UIWebView *)[cell.messageView viewWithTag:100];
        [webView loadHTMLString:message.content baseURL:nil];
        if (![_systemDict objectForKey:[NSNumber numberWithInt:indexPath.row]]) {
            webView.delegate = self;
            [cell setSubviewsFrame];
        }
        else {
            CGFloat height = [[_systemDict objectForKey:[NSNumber numberWithInt:indexPath.row]] floatValue];
            webView.delegate = nil;
            webView.frame = CGRectMake(webView.frame.origin.x, webView.frame.origin.y, webView.frame.size.width, height);
            cell.messageView.frame = CGRectMake(0, 0, kMessageBoxWidthMax, height);
            [cell setSubviewsFrame];
        }
        
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Message *model = [_dataItems objectAtIndex:indexPath.row];
    if (model.contentType == Message_ContentTypeText) {
        UIView *view = [FXTextFormat getContentViewWithMessage:model.content width:kHistoryWidthMax];
        CGFloat height = view.frame.size.height;
        return height < 44 ? 64 : height + 20;
    }
    else if (model.contentType == Message_ContentTypeImage) {
        //接收的图片保存在文件中
        NSString *cacheString = [NSString stringWithFormat:@"%@%@",model.content,kSmallImageSize];
        NSData *imageData = [FXFileHelper chatImageAlreadyLoadWithName:cacheString];
        if (imageData) {
            //已保存此图
            if ([imageData length] < 3 && [[[NSString alloc] initWithData:imageData encoding:NSUTF8StringEncoding] isEqualToString:@"NO"]) {
                return 100 + 20;
            }
            else {
                UIView *view = [FXTextFormat getContentViewWithImageData:imageData];
                if (!view) {
                    return 80 + 20;
                }
                return view.frame.size.height + 20;
            }
        }
        else {
            //未保存此图
            return 100 + 20;
        }

    }
    else {
        //通知消息
        NSNumber *height = [_systemDict objectForKey:[NSNumber numberWithInt:indexPath.row]];
        if (height) {
            return [height floatValue] + 20;
        }
        return 44 + 20;
    }
}

#pragma mark - 下载聊天图片

- (void)downloadImage:(NSString *)content forCell:(FXHistoryCell *)cell {
    FXAppDelegate *delegate = [FXAppDelegate shareFXAppDelegate];
    NSString *urlString = [NSString stringWithFormat:@"%@&userId=%d&token=%@%@",content,delegate.userID,delegate.token,kSmallImageSize];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    //    [request setValidatesSecureCertificate:NO];
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request startAsynchronous];
    
    //保存到本地的图片名
    NSString *cacheString = [NSString stringWithFormat:@"%@%@",content,kSmallImageSize];
    
    //    __weak ASIHTTPRequest *wRequest = request;
    [request setCompletionBlock:^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *imageData = [request responseData];
            [FXFileHelper documentSaveImageData:imageData withName:cacheString];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"下载完成！");
                [_historyTableView reloadData];
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

@end
