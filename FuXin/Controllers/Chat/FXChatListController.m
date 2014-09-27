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
#import "BaiduMobStat.h"

static NSString *chatCellIdentifier = @"CCI";

@interface FXChatListController ()

@end

@implementation FXChatListController

@synthesize chatListTable = _chatListTable;
@synthesize chatList = _chatList;

- (void)dealloc {
    NSLog(@"chat dealloc");
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        [FXAppDelegate showFuWuTitleForViewController:self];
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
    self.title = @"对话";
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"chatList"];

}

- (void)viewDidDisappear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"chatList"];
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
    if (kDeviceVersion >= 7.0) {
        _chatListTable.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    [self.view addSubview:_chatListTable];
    [self.chatListTable registerClass:[FXChatCell class] forCellReuseIdentifier:chatCellIdentifier];
    _chatList = [[NSMutableArray alloc] init];
    [self hiddenExtraCellLineWithTableView:_chatListTable];
}

- (void)hiddenExtraCellLineWithTableView:(UITableView *)table {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [table setTableFooterView:view];
}

#pragma mark - 更新数据

- (void)updateChatList:(NSArray *)list {
    if (list) {
        [_chatList removeAllObjects];
        [_chatList addObjectsFromArray:list];
        [_chatListTable reloadData];
        
        _messageCount = 0;
        for (NSDictionary *dict in _chatList) {
            NSNumber *count = [dict objectForKey:@"Number"];
            _messageCount += [count intValue];
        }
        if (_messageCount <= 0 ) {
            self.tabBarItem.badgeValue = nil;
        }
        else {
            self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",_messageCount];
        }
    }
}


- (void)getContactWithID:(NSString *)ID {
    FXAppDelegate *delegate = [FXAppDelegate shareFXAppDelegate];
    [FXRequestDataFormat getContactDetailWithToken:delegate.token UserID:delegate.userID ContactID:[ID intValue] Finished:^(BOOL success, NSData *response) {
        if (success) {
            //请求成功
            ContactDetailResponse *resp = [ContactDetailResponse parseFromData:response];
            NSLog(@"联系人详情：%d",resp.isSucceed);
            if (resp.isSucceed) {
                //获取成功
                [self setContactWithContact:resp.contact];
            }
            else {
                //获取失败
                if (!self.errorHandler) {
                    FXReuqestError *error = [[FXReuqestError alloc] init];
                    self.errorHandler = error;
                }
                [self.errorHandler requestDidFailWithErrorCode:resp.errorCode];
            }
        }
        else {
            //请求失败
        }
    }];
}

//保存至数据库
- (void)setContactWithContact:(Contact *)newContact {
    if (newContact) {
        ContactModel *model = [[ContactModel alloc] init];
        model.contactID = [NSString stringWithFormat:@"%d",newContact.contactId];
        model.contactNickname = newContact.name;
        model.contactRemark = newContact.customName;
        model.contactIsBlocked = newContact.isBlocked;
        model.contactPinyin = newContact.pinyin;
        model.contactLastContactTime = newContact.lastContactTime;
        model.contactSex = (ContactSex)newContact.gender;
        model.contactRelationship = newContact.source;
        model.contactIsProvider = newContact.isProvider;
        model.contactLisence = newContact.lisence;
        model.contactSignature = newContact.individualResume;
        model.fuzhi = newContact.fuzhi;
        model.orderTime = newContact.orderTime;
        model.subscribeTime = newContact.subscribeTime;
        model.contactAvatarURL = newContact.tileUrl;
        model.location = newContact.location;
        model.centerLink = newContact.centerLink;
        model.licences = newContact.licensesList;
        model.backgroundURL = newContact.backgroundUrl;
        
        //更新联系人到数据库
        [LHLDBTools saveContact:[NSArray arrayWithObject:model] withFinished:^(BOOL finish) {
            NSLog(@"update success!");
        }];
        [[NSNotificationCenter defaultCenter] postNotificationName:AddressNeedRefreshListNotification object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:ChatNeedRefreshListNotification object:nil];
    }
}

#pragma mark - 下载头像

- (void)downloadImageWithContact:(ContactModel *)contact forCell:(FXListCell *)cell {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:contact.contactAvatarURL];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([cell.imageURL isEqualToString:contact.contactAvatarURL]) {
                UIImage *image = [UIImage imageWithData:imageData];
                if ([imageData length] > 0 && image) {
                    cell.photoView.image = image;
                    [FXFileHelper documentSaveImageData:imageData withName:contact.contactAvatarURL withPathType:PathForHeadImage];
                }
            }
        });
    });
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
        NSString *ID = [rowData objectForKey:@"ID"];
        if (!contact) {
            //本地无此联系人 加载
            [self getContactWithID:ID];
        }
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
        if (contact.contactIsBlocked) {
            cell.blockView.image = [UIImage imageNamed:@"pingbi.png"];
        }
        else {
            cell.blockView.image = nil;
        }
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
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
        return 70.0f;
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
