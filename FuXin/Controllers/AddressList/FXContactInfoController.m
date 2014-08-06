//
//  FXContactInfoController.m
//  FuXin
//
//  Created by 徐宝桥 on 14-7-16.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXContactInfoController.h"
#import "FXInfoHeaderView.h"
#import "LHLDBTools.h"
#import "KxMenu.h"
#import "FXModifyController.h"

#define kInfoTitleTag    2000
#define kInfoContentTag  2001

#define kAuthFirstTag    2500

@interface FXContactInfoController ()

@property (nonatomic, strong) FXInfoHeaderView *headerView;

@property (nonatomic, strong) UIView *footerView;

@property (nonatomic, assign) BOOL isRequest;

@end

@implementation FXContactInfoController

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
    self.title = @"个人详情";
    [self setLeftNavBarItemWithImageName:@"back.png"];
    [self setRightNavBarItemWithImageName:@"info.png"];
    [self initUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    if (_headerView) {
        [_headerView setContact:_contact];
    }
}

#pragma 重写 

- (void)rightBarTouched:(id)sender {
    NSMutableArray *listArray = [NSMutableArray arrayWithObjects:
                                 [KxMenuItem menuItem:@"修改备注"
                                                image:nil
                                               target:self
                                               action:@selector(modifyContact)],
                                 nil];
    if (!_contact.contactIsBlocked) {
        [listArray addObject:[KxMenuItem menuItem:@"屏蔽此人"
                                            image:nil
                                           target:self
                                           action:@selector(blockContact)]];
    }
    CGRect rect = CGRectMake(280, 0, 20, 0);
    [KxMenu showMenuInView:self.view fromRect:rect menuItems:listArray];
}

#pragma mark - UI

- (void)initUI {
    _detailTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, kScreenHeight - 64) style:UITableViewStylePlain];
    _detailTable.dataSource = self;
    _detailTable.delegate = self;
    if (kDeviceVersion >= 7.0) {
        _detailTable.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    [self.view addSubview:_detailTable];
    
    [self initFooterView];
    _headerView = [[FXInfoHeaderView alloc] initWithFrame:CGRectMake(0, 0, 320, 150)];
    _detailTable.tableHeaderView = _headerView;
    _detailTable.tableFooterView = _footerView;
//    [_headerView setContact:_contact];
    
    [self getContactFuzhi];
}

- (void)initFooterView {
    _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 120)];
    _footerView.backgroundColor = [UIColor clearColor];
    _footerView.userInteractionEnabled = YES;
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.layer.cornerRadius = 4;
    sendBtn.frame = CGRectMake(30, 30, 260, 43);
    sendBtn.backgroundColor = kColor(209, 27, 33, 1);
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [sendBtn setTitle:@"发送消息" forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    [_footerView addSubview:sendBtn];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    line.backgroundColor = kColor(200, 200, 200, 1);
    [_footerView addSubview:line];
}

- (void)setValueForUI {
    [_headerView setContact:_contact];
    [_detailTable reloadData];
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
                if (!self.errorHandler) {
                    self.errorHandler = [[FXReuqestError alloc] init];
                }
                [self.errorHandler requestDidFailWithErrorCode:resp.errorCode];
            }
        }
        else {
            //请求失败
        }
    }];
}

//加载联系人详细信息仅查看
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
        //防止和列表头像不一致
        model.contactAvatarURL = _contact.contactAvatarURL;
        model.location = newContact.location;
        model.centerLink = newContact.centerLink;
        model.licences = newContact.licensesList;
        model.backgroundURL = newContact.backgroundUrl;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if (!model.backgroundURL || [model.backgroundURL isEqualToString:@""]) {
                //背景链接为空
                model.backgroundURL = _contact.backgroundURL;
            }
            else {
                if (![model.backgroundURL isEqualToString:_contact.backgroundURL]) {
                    //更新背景
                    NSData *backData = [self loadBackgroundWithURLString:model.backgroundURL];
                    [FXFileHelper documentSaveImageData:backData withName:model.backgroundURL withPathType:PathForHeadImage];
                }
                else {
                    //url相同但是图片未下载成功
                    UIImage *image = [UIImage imageWithData:[FXFileHelper headImageWithName:model.backgroundURL]];
                    if (!image) {
                        [FXFileHelper removeAncientHeadImageIfExistWithName:model.backgroundURL];
                        NSData *backData = [self loadBackgroundWithURLString:model.backgroundURL];
                        [FXFileHelper documentSaveImageData:backData withName:model.backgroundURL withPathType:PathForHeadImage];
                    }
                }
            }
        });
        _contact = model;
        [self updateAfterModify];
    }
}

- (NSData *)loadBackgroundWithURLString:(NSString *)url {
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setValidatesSecureCertificate:NO];
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request startSynchronous];
    return request.responseData;
}

#pragma mark - block

- (void)blockContact {
    if (_isRequest) {
        return;
    }
    _isRequest = YES;
    FXAppDelegate *delegate = [FXAppDelegate shareFXAppDelegate];
    [FXRequestDataFormat blockContactWithToken:delegate.token UserID:delegate.userID ContactID:[_ID intValue] IsBlocked:YES Finished:^(BOOL success, NSData *response) {
        NSString *info = @"";
        _isRequest = NO;
        if (success) {
            //请求成功
            BlockContactResponse *resp = [BlockContactResponse parseFromData:response];
            NSLog(@"屏蔽 %d",resp.isSucceed);
            if (resp.isSucceed) {
                //屏蔽成功
                info = @"成功屏蔽此联系人！";
                _contact.contactIsBlocked = YES;
                [LHLDBTools findContactWithContactID:_ID withFinished:^(ContactModel *model, NSString *error) {
                    model.contactIsBlocked = YES;
                    [LHLDBTools saveContact:[NSArray arrayWithObject:model] withFinished:^(BOOL finish) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:AddressNeedRefreshListNotification object:nil];
                        [[NSNotificationCenter defaultCenter] postNotificationName:ChatNeedRefreshListNotification object:nil];
                    }];
                }];
            }
            else {
                //屏蔽失败
                if (!self.errorHandler) {
                    self.errorHandler = [[FXReuqestError alloc] init];
                }
                [self.errorHandler requestDidFailWithErrorCode:resp.errorCode];
                info = @"屏蔽联系人失败！";
            }
        }
        else {
            //请求失败
            info = @"请求超时！";
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

- (void)modifyContact {
    FXModifyController *modifyController = [[FXModifyController alloc] init];
    modifyController.type = ModifyContact;
    modifyController.contact = _contact;
    [self.navigationController pushViewController:modifyController animated:YES];
}

- (void)modifyContactRemark:(NSString *)remark {
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
                if (!self.errorHandler) {
                    self.errorHandler = [[FXReuqestError alloc] init];
                }
                [self.errorHandler requestDidFailWithErrorCode:resp.errorCode];
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

- (void)showAuthForCell:(UITableViewCell *)cell withDataArray:(NSArray *)item {
    CGFloat originX = 280;
    for (int i = [item count] - 1; i >= 0; i--) {
        License *licence = [item objectAtIndex:i];
        NSLog(@"%@,%@,%d",licence.name,licence.iconUrl,licence.order);
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(originX, 10, 24, 24)];
        imageView.tag = kAuthFirstTag + i;
        [cell.contentView addSubview:imageView];
        [self downloadImageForImageView:imageView withURL:licence.iconUrl];
        originX -= 30;
    }
}

- (void)downloadImageForImageView:(UIImageView *)imageView withURL:(NSString *)urlString {
    BOOL needLoad = NO;
    if ([FXFileHelper isHeadImageExist:urlString]) {
        UIImage *image = [UIImage imageWithData:[FXFileHelper headImageWithName:urlString]];
        if (!image) {
            [FXFileHelper removeAncientHeadImageIfExistWithName:urlString];
            needLoad = YES;
        }
    }
    else {
        needLoad = YES;
    }
    if (needLoad) {
        NSURL *url = [NSURL URLWithString:urlString];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        [request setTimeOutSeconds:kGetMessageDuration - 1];
        [request setValidatesSecureCertificate:NO];
        [request setDefaultResponseEncoding:NSUTF8StringEncoding];
        [request startAsynchronous];
        __weak ASIHTTPRequest *wRequest = request;
        [request setCompletionBlock:^{
            UIImage *image = [UIImage imageWithData:wRequest.responseData];
            if (image && imageView) {
                imageView.image = image;
                [FXFileHelper documentSaveImageData:wRequest.responseData
                                           withName:urlString
                                       withPathType:PathForHeadImage];
            }
        }];
    }
    else {
        UIImage *image = [UIImage imageWithData:[FXFileHelper headImageWithName:urlString]];
        imageView.image = image;
    }
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_contact.contactIsProvider) {
        return 5;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 80, 25)];
        titleLabel.tag = kInfoTitleTag;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = [UIFont boldSystemFontOfSize:14];
        titleLabel.textColor = [UIColor blackColor];
        [cell.contentView addSubview:titleLabel];
        
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(95, 3, 203, 40)];
        contentLabel.tag = kInfoContentTag;
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.textAlignment = NSTextAlignmentRight;
        contentLabel.font = [UIFont systemFontOfSize:13];
        contentLabel.textColor = [UIColor grayColor];
        [cell.contentView addSubview:contentLabel];
    }
    UILabel *title = (UILabel *)[cell.contentView viewWithTag:kInfoTitleTag];
    UILabel *content = (UILabel *)[cell.contentView viewWithTag:kInfoContentTag];
    if (_contact.contactIsProvider) {
        switch (indexPath.row) {
            case 0: {
                title.text = @"认证行业";
                content.text = nil;
                content.hidden = YES;
                [self showAuthForCell:cell withDataArray:_contact.licences];
//                content.text = _contact.contactLisence;
            }
                break;
            case 1: {
                title.text = @"福指";
                content.text = _contact.fuzhi;
            }
                break;
            case 2: {
                title.text = @"性别";
                if (_contact.contactSex == 0) {
                    content.text = @"男";
                }
                else if (_contact.contactSex == 1) {
                    content.text = @"女";
                }
                else {
                    content.text = @"保密";
                }
            }
                break;
            case 3: {
                title.text = @"地址";
                content.text = _contact.location;
            }
                break;
            case 4: {
                CGSize size = [_contact.contactSignature sizeWithFont:[UIFont systemFontOfSize:13]
                                                    constrainedToSize:CGSizeMake(215, CGFLOAT_MAX)];
                size.height = size.height < 44 ? 44 : size.height;
                title.frame = CGRectMake(15, 5, 80, size.height);
                title.text = @"福师简介";
                content.textAlignment = NSTextAlignmentLeft;
                content.numberOfLines = 0;
                //            int row = (int)size.width / 215 + 1;
                //            if (row >= 2 && row <= 4) {
                //                content.frame = CGRectMake(85, 5, 215, 17 * row);
                //            }
                //            if (row > 4) {
                //                content.frame = CGRectMake(85, 5, 215, 70);
                //            }
                content.frame = CGRectMake(85, 5, 215, size.height);
                content.text = _contact.contactSignature;
            }
                break;
            default:
                break;
        }
    }
    else {
        switch (indexPath.row) {
            case 0: {
                title.text = @"性别";
                if (_contact.contactSex == 0) {
                    content.text = @"男";
                }
                else if (_contact.contactSex == 1) {
                    content.text = @"女";
                }
                else {
                    content.text = @"保密";
                }
            }
                break;
            case 1: {
                title.text = @"地址";
                content.text = _contact.location;
            }
                break;
            default:
                break;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 4 && _contact.contactIsProvider) {
        ContactModel *data = _contact;
        CGSize size = [data.contactSignature sizeWithFont:[UIFont systemFontOfSize:13]
                                        constrainedToSize:CGSizeMake(215, CGFLOAT_MAX)];
        size.height = size.height < 44 ? 44 : size.height;
        //上下偏移量各5
        return size.height + 10;
//        int row = (int)size.width / 215 + 1;
//        if (row <= 2) {
//            return 44;
//        }
//        else if (row > 4) {
//            return 80;
//        }
//        else {
//            return row * 20;
//        }
    }
    return 44;
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

@end
