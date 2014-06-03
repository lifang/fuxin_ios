//
//  FXBlockedContactsController.m
//  FuXin
//
//  Created by lihongliang on 14-6-3.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXBlockedContactsController.h"
#import "LHLDBTools.h"
#import "FXRequestDataFormat.h"

#define kBlank_Size    15   //边缘空白
#define kTopViewHeight   40

@interface FXBlockedContactsController ()

@end

static NSString *cellIdentifier = @"cell";
@implementation FXBlockedContactsController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)initUI{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(kBlank_Size, 0, 320 - 2 * kBlank_Size, kScreenHeight - 64 - 49) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    if (kDeviceVersion >= 7.) {
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    _tableView.separatorColor = kColor(191, 191, 191, 1);
    UIView *footer = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.tableFooterView = footer;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[FXBlockedContactCell class] forCellReuseIdentifier:cellIdentifier];
    [self.view addSubview:_tableView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
    self.dataArray = [NSMutableArray array];
    [LHLDBTools getAllContactsWithFinished:^(NSArray *contactsArray, NSString *errorMessage) {
        for (ContactModel *contact in contactsArray) {
            if (contact.contactIsBlocked) {
                [self.dataArray addObject:contact];
            }
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (FXBlockedContactCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FXBlockedContactCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    ContactModel *contact = self.dataArray[indexPath.row];
    cell.contactModel = contact;
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //点击cell ,弹出联系人信息
}

#pragma mark BlockedContactCell delegate
- (void)blockedContactCell:(FXBlockedContactCell *)cell recoverContact:(ContactModel *)contact{
    NSUInteger row = [self.dataArray indexOfObject:contact];
    contact.contactIsBlocked = NO;
    [FXRequestDataFormat blockContactWithToken:[FXAppDelegate shareFXAppDelegate].token
                                        UserID:[FXAppDelegate shareFXAppDelegate].userID
                                     ContactID:(int32_t)contact.contactID.intValue
                                     IsBlocked:NO
                                      Finished:^(BOOL success, NSData *response) {
                                          if (success) {
                                              //请求成功
                                              BlockContactResponse *resp = [BlockContactResponse parseFromData:response];
                                              if (resp.isSucceed) {
                                                  //恢复成功
                                                  [LHLDBTools saveContact:@[contact] withFinished:^(BOOL flag) {
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          [self.dataArray removeObjectAtIndex:row];
                                                          [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                                                      });
                                                  }];
                                              }else{
                                                  //恢复失败
                                              }
                                          }else{
                                              //请求失败
                                              
                                          }
                                      }];
}

@end
