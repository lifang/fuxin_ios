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
#import "FXInfoView.h"

#define kBlank_Size    15   //边缘空白
#define kTopViewHeight   40

@interface FXBlockedContactsController ()
@property (strong ,nonatomic) FXBlockedContactInfoView *contactInfoView;

@property (nonatomic, assign) BOOL isRequest;
@property (nonatomic, strong) FXInfoView *infoView;

@end

static NSString *cellIdentifier = @"cell";
@implementation FXBlockedContactsController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)initUI{
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    
    [self setLeftNavBarItemWithImageName:@"back.png"];
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
    self.title = @"屏蔽管理";
    [self initInfoView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"blockedContacts"];

}

- (void)viewDidDisappear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"blockedContacts"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //点击cell ,弹出联系人信息
    ContactModel *contact = self.dataArray[indexPath.row];
    if (!_contactInfoView) {
        _contactInfoView = [[FXBlockedContactInfoView alloc] initWithFrame:(CGRect){0 ,0 ,self.view.frame.size}];
        [self.view addSubview:_contactInfoView];
        _contactInfoView.delegate = self;
    }
    _contactInfoView.alpha = 0;
    _contactInfoView.hidden = NO;
    [_contactInfoView setContact:contact];
    [UIView animateWithDuration:.4 animations:^{
        _contactInfoView.alpha = 1;
    }];
}

#pragma mark BlockedContactCell delegate
- (void)blockedContactCell:(FXBlockedContactCell *)cell recoverContact:(ContactModel *)contact{
    if (_isRequest) {
        return;
    }
    [_infoView show];
    [_infoView setText:@"正在取消屏蔽..."];
    _isRequest = YES;
    NSUInteger row = [self.dataArray indexOfObject:contact];
    contact.contactIsBlocked = NO;
    [FXRequestDataFormat blockContactWithToken:[FXAppDelegate shareFXAppDelegate].token UserID:[FXAppDelegate shareFXAppDelegate].userID ContactID:(int32_t)contact.contactID.intValue IsBlocked:NO Finished:^(BOOL success, NSData *response) {
        if (success) {
            //请求成功
            BlockContactResponse *resp = [BlockContactResponse parseFromData:response];
            if (resp.isSucceed) {
                //恢复成功
                [_infoView setText:@"成功取消屏蔽！"];
                [LHLDBTools saveContact:@[contact] withFinished:^(BOOL flag) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.delegate = nil;
                        [self.dataArray removeObjectAtIndex:row];
                        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                        [[NSNotificationCenter defaultCenter] postNotificationName:AddressNeedRefreshListNotification object:nil];
                        [[NSNotificationCenter defaultCenter] postNotificationName:ChatNeedRefreshListNotification object:nil];
                    });
                }];
            }else{
                //恢复失败
                [_infoView setText:@"取消屏蔽失败！"];
                if (!self.errorHandler) {
                    self.errorHandler = [[FXReuqestError alloc] init];
                }
                [self.errorHandler requestDidFailWithErrorCode:resp.errorCode];
            }
        }else{
            //请求失败
            [_infoView setText:@"网络请求超时！"];
        }
        _isRequest = NO;
        [_infoView hide];
    }];
}

#pragma mark BlockedContactInfoView delegate
- (void)blockedContactInfoViewRecover:(FXBlockedContactInfoView *)infoView{
    [self blockedContactCell:nil recoverContact:infoView.contact];
}
@end
