//
//  FXChatListController.m
//  FuXin
//
//  Created by 徐宝桥 on 14-5-19.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXChatListController.h"
#import "FXChatCell.h"
#import "FXTimeFormat.h"
#import "LHLDBTools.h"

static NSString *chatCellIdentifier = @"CCI";

@interface FXChatListController ()

@end

@implementation FXChatListController

@synthesize chatListTable = _chatListTable;
@synthesize chatList = _chatList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [FXAppDelegate showFuWuTitleForViewController:self];
    }
    return self;
}

- (id)init {
    if (self = [super init]) {
        [self initUI];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)initUI {
    _chatListTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, kScreenHeight - 64 - 49)];
    _chatListTable.delegate = self;
    _chatListTable.dataSource = self;
    [self.view addSubview:_chatListTable];
    [self.chatListTable registerClass:[FXChatCell class] forCellReuseIdentifier:chatCellIdentifier];
    _chatList = [[NSMutableArray alloc] init];
    [self hiddenExtraCellLineWithTableView:_chatListTable];
}

#pragma mark - 更新数据

- (void)updateChatList:(NSArray *)list {
    if (list) {
        [_chatList removeAllObjects];
        [_chatList addObjectsFromArray:list];
        [_chatListTable reloadData];
    }
}

#pragma mark - 重写

- (IBAction)rightBarTouched:(id)sender {

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _chatListTable) {
        return 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _chatListTable) {
        return [_chatList count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _chatListTable) {
        FXChatCell *cell = [tableView dequeueReusableCellWithIdentifier:chatCellIdentifier forIndexPath:indexPath];
        NSDictionary *rowData = [_chatList objectAtIndex:indexPath.row];
        ContactModel *contact = [rowData objectForKey:@"Contact"];
        if (contact.contactRemark && ![contact.contactRemark isEqualToString:@""]) {
            cell.nameLabel.text = contact.contactRemark;
        }
        else {
            cell.nameLabel.text = contact.contactNickname;
        }
        [cell setNumber:[NSString stringWithFormat:@"%@",[rowData objectForKey:@"Number"]]];
        cell.timeLabel.text = [FXTimeFormat setTimeFormatWithString:[rowData objectForKey:@"Time"]];

        cell.detailLabel.text = [rowData objectForKey:@"Record"];
        cell.imageURL = contact.contactAvatarURL;
        if ([FXFileHelper isHeadImageExist:contact.contactAvatarURL]) {
            NSData *imageData = [FXFileHelper headImageWithName:contact.contactAvatarURL];
            cell.photoView.image = [UIImage imageWithData:imageData];
        }
        else {
            cell.photoView.image = [UIImage imageNamed:@"placeholder.png"];
            [self downloadImageWithContact:contact forCell:cell];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        // Configure the cell...
        
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _chatListTable) {
        //清空信息条数
        FXChatCell *cell = (FXChatCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell setNumber:@""];
        FXChatViewController *chat = [[FXChatViewController alloc] init];
        NSDictionary *rowData = [_chatList objectAtIndex:indexPath.row];
        chat.contact = [rowData objectForKey:@"Contact"];
        chat.ID = [rowData objectForKey:@"ID"];
        chat.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:chat animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _chatListTable) {
        return 54.0f;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView == _chatListTable) {
        return nil;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == _chatListTable) {
        return 0;
    }
    return 0;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSString *userID = [[_chatList objectAtIndex:indexPath.row] objectForKey:@"ID"];
        //数组中删除
        [_chatList removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        //最近对话中删除
        [LHLDBTools deleteConversationWithID:userID withFinished:^(BOOL finish) {
            
        }];
    }
}

@end
