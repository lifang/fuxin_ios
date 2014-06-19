//
//  FXContactController.m
//  FuXin
//
//  Created by 徐宝桥 on 14-6-16.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXContactController.h"
#import "FXContactCell.h"
#import "FXChatViewController.h"

#define kContactTitleTag      50
#define kContactContentTag    51

@interface FXContactController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) ContactModel *downloadContact;

@end

@implementation FXContactController

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
    [self getContactFuzhi];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI {
    _detailTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, kScreenHeight - 64) style:UITableViewStylePlain];
    _detailTable.dataSource = self;
    _detailTable.delegate = self;
    [self.view addSubview:_detailTable];
}

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
                [_detailTable reloadData];
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

//加载联系人详细信息紧查看 并不保存至数据库
- (void)setContactWithContact:(Contact *)newContact {
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
    //防止和列表头像不一致
    model.contactAvatarURL = _contact.contactAvatarURL;
    _downloadContact = model;
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_contact.contactIsProvider) {
        return 4;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactModel *data = _contact;
    if (_downloadContact) {
        data = _downloadContact;
    }
    if (indexPath.row == 0) {
        FXContactCell *cell = [[FXContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        if ([FXFileHelper isHeadImageExist:data.contactAvatarURL]) {
            NSData *imageData = [FXFileHelper headImageWithName:data.contactAvatarURL];
            cell.photoView.image = [UIImage imageWithData:imageData];
        }
        else {
            cell.photoView.image = [UIImage imageNamed:@"placeholder.png"];
        }
        cell.nameLabel.text = data.contactNickname;
        if (data.contactSex == ContactSexMale) {
            cell.sexView.image = [UIImage imageNamed:@"male.png"];
        }
        else if (data.contactSex == ContactSexFemale) {
            cell.sexView.image = [UIImage imageNamed:@"female.png"];
        }
        cell.remarkLabel.text = [NSString stringWithFormat:@"备注：%@",data.contactRemark];
        return cell;
    }
    else {
        static NSString *identifier = @"detail";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];

            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 70, 25)];
            titleLabel.tag = kContactTitleTag;
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.textAlignment = NSTextAlignmentLeft;
            titleLabel.font = [UIFont systemFontOfSize:13];
            titleLabel.textColor = [UIColor grayColor];
            [cell.contentView addSubview:titleLabel];
            
            UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 3, 215, 40)];
            contentLabel.tag = kContactContentTag;
            contentLabel.backgroundColor = [UIColor clearColor];
            contentLabel.textAlignment = NSTextAlignmentRight;
            contentLabel.font = [UIFont systemFontOfSize:13];
            contentLabel.textColor = [UIColor grayColor];
            [cell.contentView addSubview:contentLabel];
        }
        UILabel *title = (UILabel *)[cell.contentView viewWithTag:kContactTitleTag];
        UILabel *content = (UILabel *)[cell.contentView viewWithTag:kContactContentTag];
        switch (indexPath.row) {
            case 1: {
                title.text = @"行业认证：";
                content.text = data.contactLisence;
            }
                break;
            case 2: {
                title.text = @"福       指：";
                content.text = data.fuzhi;
            }
                break;
            case 3: {
                title.text = @"个人简介：";
                content.textAlignment = NSTextAlignmentLeft;
                content.numberOfLines = 4;
                CGSize size = [data.contactSignature sizeWithFont:[UIFont systemFontOfSize:13]
                                                constrainedToSize:CGSizeMake(CGFLOAT_MAX, 20)];
                int row = (int)size.width / 215 + 1;
                if (row >= 2 && row <= 4) {
                    content.frame = CGRectMake(85, 5, 215, 20 * row);
                }
                if (row > 4) {
                    content.frame = CGRectMake(85, 5, 215, 80);
                }
                content.text = data.contactSignature;
            }
                break;
            default:
                break;
        }
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
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
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 200;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 50;
    }
    else if (indexPath.row == 3) {
        ContactModel *data = _contact;
        if (_downloadContact) {
            data = _downloadContact;
        }
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - action 

- (void)send {
    FXChatViewController *chatC = [[FXChatViewController alloc] init];
    chatC.contact = _contact;
    chatC.ID = _contact.contactID;
    [self.navigationController pushViewController:chatC animated:YES];
}

@end
