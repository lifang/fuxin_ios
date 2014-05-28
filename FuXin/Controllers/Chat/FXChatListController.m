//
//  FXChatListController.m
//  FuXin
//
//  Created by 徐宝桥 on 14-5-19.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXChatListController.h"
#import "FXChatCell.h"

static NSString *chatCellIdentifier = @"CCI";

@interface FXChatListController ()

@end

@implementation FXChatListController

@synthesize chatListTable = _chatListTable;
@synthesize messageDict = _messageDict;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
        return [[_messageDict allKeys] count];
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _chatListTable) {
        FXChatCell *cell = [tableView dequeueReusableCellWithIdentifier:chatCellIdentifier forIndexPath:indexPath];
        NSNumber *ID = [[_messageDict allKeys] objectAtIndex:indexPath.row];
        cell.nameLabel.text = [NSString stringWithFormat:@"%@",ID];
        cell.numberLabel.text = [NSString stringWithFormat:@"%d",[[_messageDict objectForKey:ID] count]];
        cell.detailLabel.text = [(Message *)[[_messageDict objectForKey:ID] objectAtIndex:0] content];
//        cell.photoView.image = [UIImage imageNamed:@"placeholder.png"];
//        cell.nameLabel.text = @"钱学生";
//        cell.detailLabel.text = @"好的，下周课堂见";
//        cell.timeLabel.text = @"早上9：30";
//        cell.numberLabel.text = @"99";
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        // Configure the cell...
        
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _chatListTable) {
        FXChatViewController *chat = [[FXChatViewController alloc] init];
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
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

@end
