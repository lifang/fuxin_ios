//
//  FXContactDetailController.m
//  FuXin
//
//  Created by 徐宝桥 on 14-6-24.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXContactDetailController.h"
#import "FXContactDetailView.h"
#import "LHLDBTools.h"

#define kContactTitleTag      50
#define kContactContentTag    51

@interface FXContactDetailController ()<UITextFieldDelegate>

@property (nonatomic, strong) UISwitch *blockBtn;

@property (nonatomic, strong) UITextField *remarkField;

@property (nonatomic, strong) FXContactDetailView *headerView;

@end

@implementation FXContactDetailController

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
    self.title = @"详细资料";
    [self setLeftNavBarItemWithImageName:@"back.png"];
    [self initUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)initUI {
    _detailTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, kScreenHeight - 64) style:UITableViewStylePlain];
    _detailTable.dataSource = self;
    _detailTable.delegate = self;
    UIView *view = [[UIView alloc] initWithFrame:_detailTable.bounds];
    view.backgroundColor = kColor(239, 239, 244, 1);
    _detailTable.backgroundView = view;
    if (kDeviceVersion >= 7.0) {
        _detailTable.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    [self.view addSubview:_detailTable];
    
    _headerView = [[FXContactDetailView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
    _detailTable.tableHeaderView = _headerView;
    [_headerView setContact:_contact];
    
    _blockBtn = [[UISwitch alloc] init];
    if (_contact.contactIsBlocked) {
        _blockBtn.on = YES;
    }
    else {
        _blockBtn.on = NO;
    }
    _remarkField = [[UITextField alloc] init];
    
    [self getContactFuzhi];
}

- (void)setValueForUI {
    [_headerView setContact:_contact];
    [_detailTable reloadData];
}

//请求时禁掉用户交互
- (void)userEnabledWeatherRequest:(BOOL)isRequest {
    if (isRequest) {
        _blockBtn.userInteractionEnabled = NO;
        _remarkField.userInteractionEnabled = NO;
    }
    else {
        _blockBtn.userInteractionEnabled = YES;
        _remarkField.userInteractionEnabled = YES;
    }
}

#pragma mark - download

- (void)getContactFuzhi {
    FXAppDelegate *delegate = [FXAppDelegate shareFXAppDelegate];
    [FXRequestDataFormat getContactDetailWithToken:delegate.token UserID:delegate.userID ContactID:[_contact.contactID intValue] Finished:^(BOOL success, NSData *response) {
        if (success) {
            //请求成功
            ContactDetailResponse *resp = [ContactDetailResponse parseFromData:response];
            NSLog(@"联系人详情：%d",resp.isSucceed);
            if (resp.isSucceed) {
                //获取成功
                [self setContactWithContact:resp.contact];
                [self setValueForUI];
            }
            else {
                //获取失败
            }
        }
        else {
            //请求失败
        }
    }];
}

//加载联系人详细信息仅查看 并不保存至数据库
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
        //防止和列表头像不一致
        model.contactAvatarURL = _contact.contactAvatarURL;
        _contact = model;
        [self updateAfterModify];
    }
}

#pragma mark - block

- (void)blockContact:(UISwitch *)switchBtn {
    [self userEnabledWeatherRequest:YES];
    FXAppDelegate *delegate = [FXAppDelegate shareFXAppDelegate];
    [FXRequestDataFormat blockContactWithToken:delegate.token UserID:delegate.userID ContactID:[_ID intValue] IsBlocked:switchBtn.isOn Finished:^(BOOL success, NSData *response) {
        [self userEnabledWeatherRequest:NO];
        NSString *info = @"";
        if (success) {
            //请求成功
            BlockContactResponse *resp = [BlockContactResponse parseFromData:response];
            NSLog(@"屏蔽 %d",resp.isSucceed);
            if (resp.isSucceed) {
                //屏蔽成功
                if (switchBtn.isOn) {
                    info = @"成功屏蔽此联系人！";
                }
                else {
                    info = @"取消屏蔽成功！";
                }
                _contact.contactIsBlocked = switchBtn.isOn;
                [LHLDBTools findContactWithContactID:_ID withFinished:^(ContactModel *model, NSString *error) {
                    model.contactIsBlocked = switchBtn.isOn;
                    [LHLDBTools saveContact:[NSArray arrayWithObject:model] withFinished:^(BOOL finish) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:AddressNeedRefreshListNotification object:nil];
                        [[NSNotificationCenter defaultCenter] postNotificationName:ChatNeedRefreshListNotification object:nil];
                    }];
                }];
            }
            else {
                //屏蔽失败
                info = @"屏蔽联系人失败！";
                switchBtn.on = !switchBtn.isOn;
            }
        }
        else {
            //请求失败
            info = @"请求超时！";
            switchBtn.on = !switchBtn.isOn;
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:info
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }];
}

#pragma mark - 修改联系人

- (void)modifyContactRemark:(NSString *)remark {
    [self userEnabledWeatherRequest:YES];
    Contact *contact = [[[[[[[[[[[[[[[[Contact builder]
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
                         setIndividualResume:_contact.contactSignature]
                        setOrderTime:_contact.orderTime]
                         setSubscribeTime:_contact.subscribeTime] build];
    FXAppDelegate *delegate = [FXAppDelegate shareFXAppDelegate];
    [FXRequestDataFormat modifyContactDetailWithToken:delegate.token UserID:delegate.userID Contact:contact Finished:^(BOOL success, NSData *response) {
        [self userEnabledWeatherRequest:NO];
        if (success) {
            //请求成功
            ChangeContactDetailResponse *resp = [ChangeContactDetailResponse parseFromData:response];
            NSString *info = @"";
            if (resp.isSucceed) {
                //修改成功
                _contact.contactRemark = remark;
                [self updateAfterModify];
                info = @"修改联系人备注成功";
            }
            else {
                //修改失败
                info = @"修改联系人备注失败";
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                            message:info
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        else {
            //请求失败
        }
    }];
}

//修改联系人成功后更新界面
- (void)updateAfterModify {
    //更新联系人到数据库
    [LHLDBTools saveContact:[NSArray arrayWithObject:_contact] withFinished:^(BOOL finish) {
        NSLog(@"update success!");
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:AddressNeedRefreshListNotification object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:ChatNeedRefreshListNotification object:nil];
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_contact.contactIsProvider) {
        return 3;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return 1;
    }
    else {
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactModel *data = _contact;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 80, 25)];
        titleLabel.tag = kContactTitleTag;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.textColor = [UIColor grayColor];
        [cell.contentView addSubview:titleLabel];
        if (indexPath.section == 0 && indexPath.row == 0) {
            _remarkField.frame = CGRectMake(95, 4, 205, 36);
            _remarkField.text = data.contactRemark;
            _remarkField.textAlignment = NSTextAlignmentRight;
            _remarkField.clearButtonMode = UITextFieldViewModeWhileEditing;
            _remarkField.returnKeyType = UIReturnKeyDone;
            _remarkField.font = [UIFont systemFontOfSize:13];
            _remarkField.delegate = self;
            [cell.contentView addSubview:_remarkField];
        }
        else if (indexPath.section == 1 && indexPath.row == 0) {
            _blockBtn.frame = CGRectMake(260, 6, 50, 30);
            [_blockBtn addTarget:self action:@selector(blockContact:) forControlEvents:UIControlEventValueChanged];
            if (kDeviceVersion >= 7.0) {
                _blockBtn.onTintColor = [UIColor redColor];
                _blockBtn.frame = CGRectMake(260, 7, 50, 30);
            }
            else {
                _blockBtn.onTintColor = [UIColor redColor];
                _blockBtn.frame = CGRectMake(220, 7, 30, 30);
            }
            [cell.contentView addSubview:_blockBtn];
        }
        else {
            UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(95, 3, 203, 40)];
            contentLabel.tag = kContactContentTag;
            contentLabel.backgroundColor = [UIColor clearColor];
            contentLabel.textAlignment = NSTextAlignmentRight;
            contentLabel.font = [UIFont systemFontOfSize:13];
            contentLabel.textColor = [UIColor grayColor];
            [cell.contentView addSubview:contentLabel];
        }
        if (kDeviceVersion < 7.0) {
            UIView *view = [[UIView alloc] initWithFrame:cell.bounds];
            view.backgroundColor = [UIColor whiteColor];
            cell.backgroundView = view;
        }
    }
    UILabel *title = (UILabel *)[cell.contentView viewWithTag:kContactTitleTag];
    UILabel *content = (UILabel *)[cell.contentView viewWithTag:kContactContentTag];
    switch (indexPath.section) {
        case 0: {
            title.text = @"备       注";
            content.text = data.contactRemark;
        }
            break;
        case 1: {
            title.text = @"屏蔽他（她）";
        }
            break;
        case 2: {
            switch (indexPath.row) {
                case 0: {
                    title.text = @"行业认证";
                    content.text = data.contactLisence;
                }
                    break;
                case 1: {
                    title.text = @"福       指";
                    content.text = data.fuzhi;
                }
                    break;
                case 2: {
                    title.text = @"个人简介";
                    content.textAlignment = NSTextAlignmentLeft;
                    content.numberOfLines = 4;
                    CGSize size = [data.contactSignature sizeWithFont:[UIFont systemFontOfSize:13]
                                                    constrainedToSize:CGSizeMake(CGFLOAT_MAX, 20)];
                    int row = (int)size.width / 215 + 1;
                    if (row >= 2 && row <= 4) {
                        content.frame = CGRectMake(85, 5, 215, 17 * row);
                    }
                    if (row > 4) {
                        content.frame = CGRectMake(85, 5, 215, 70);
                    }
                    content.text = data.contactSignature;
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    ContactModel *data = _contact;
    BOOL showFooter = (data.contactIsProvider && section == 2) ||
    (!data.contactIsProvider && section == 1);
    if (showFooter) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 120)];
        view.backgroundColor = [UIColor clearColor];
        view.userInteractionEnabled = YES;
        UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sendBtn.layer.cornerRadius = 4;
        sendBtn.frame = CGRectMake(30, 50, 260, 43);
        sendBtn.backgroundColor = kColor(209, 27, 33, 1);
        [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [sendBtn setTitle:@"发送消息" forState:UIControlStateNormal];
        [sendBtn addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:sendBtn];
        
//        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
//        line.backgroundColor = kColor(200, 200, 200, 1);
//        [view addSubview:line];
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section != 0) {
        return 10;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    ContactModel *data = _contact;
    BOOL showFooter = (data.contactIsProvider && section == 2) ||
    (!data.contactIsProvider && section == 1);
    if (showFooter) {
        return 120;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2 && indexPath.row == 2) {
        ContactModel *data = _contact;
        CGSize size = [data.contactSignature sizeWithFont:[UIFont systemFontOfSize:13]
                                        constrainedToSize:CGSizeMake(CGFLOAT_MAX, 20)];
        int row = (int)size.width / 215 + 1;
        if (row <= 2) {
            return 44;
        }
        else if (row > 4) {
            return 80;
        }
        else {
            return row * 20;
        }
    }
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section != 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - action

- (void)send {
    FXChatViewController *chatC = [[FXChatViewController alloc] init];
    chatC.contact = _contact;
    chatC.ID = _contact.contactID;
    chatC.isFromDetail = YES;
    [self.navigationController pushViewController:chatC animated:YES];
}

#pragma mark - TextField

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self modifyContactRemark:textField.text];
    return YES;
}

@end
