//
//  FXUserSettingController.m
//  FuXin
//
//  Created by 徐宝桥 on 14-6-3.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXUserSettingController.h"
#import "FXRequestDataFormat.h"

#define kTitleTag       200
#define kContentTag     201

@interface FXUserSettingController ()<UITextFieldDelegate,UIActionSheetDelegate>

@property (nonatomic, strong) UIImageView *photoView;
@property (nonatomic, strong) UITextField *nameField;

@end

@implementation FXUserSettingController

@synthesize userInfo = _userInfo;
@synthesize photoView = _photoView;
@synthesize nameField = _nameField;
@synthesize userTableView = _userTableView;

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
    [self setLeftNavBarItemWithImageName:@"back.png"];
    [self setRightNavBarItemWithImageName:@"save.png"];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [FXAppDelegate shareFXAppDelegate].attributedTitleLabel.text = @"我的信息";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 重写

- (void)rightBarTouched:(id)sender {
    Profile *modify = [[[[[[[[[[[[[Profile builder]
                                  setUserId:_userInfo.userId]
                                 setName:_userInfo.name]
                                setNickName:_nameField.text]
                               setGender:_userInfo.gender]
                              setMobilePhoneNum:_userInfo.mobilePhoneNum]
                             setEmail:_userInfo.email]
                            setBirthday:_userInfo.birthday]
                           setTileUrl:_userInfo.tileUrl]
                          setIsProvider:_userInfo.isProvider]
                         setLisence:_userInfo.lisence]
                        setPublishClassType:_userInfo.publishClassType] build];
    FXAppDelegate *delegate = [FXAppDelegate shareFXAppDelegate];
    [FXRequestDataFormat changeProfileWithToken:delegate.token UserID:delegate.userID Profile:modify Finished:^(BOOL success, NSData *response) {
        if (success) {
            //请求成功
            ChangeProfileResponse *resp = [ChangeProfileResponse parseFromData:response];
            NSLog(@"修改个人信息 =%d %@",resp.isSucceed,resp.profile.nickName);
            if (resp.isSucceed) {
                //修改成功
            
            }
            else {
                //修改失败
            }
        }
        else {
            //请求失败
        }
    }];
}

#pragma mark - UI

- (void)initUI {
    _userTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, kScreenHeight - 64) style:UITableViewStylePlain];
    _userTableView.delegate = self;
    _userTableView.dataSource = self;
    _userTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _userTableView.backgroundColor = [UIColor whiteColor];
    _userTableView.tableHeaderView = [self setHeaderView];
    [self.view addSubview:_userTableView];
}

- (UIView *)setHeaderView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    headerView.backgroundColor = [UIColor clearColor];
    
    UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 60, 25)];
    lab1.backgroundColor = [UIColor clearColor];
    lab1.textColor = [UIColor blackColor];
    lab1.textAlignment = NSTextAlignmentLeft;
    lab1.font = [UIFont systemFontOfSize:14.0];
    lab1.text = @"头像：";
    [headerView addSubview:lab1];
    
    _photoView = [[UIImageView alloc] initWithFrame:CGRectMake(266, 20, 34, 34)];
    _photoView.layer.cornerRadius = _photoView.frame.size.height / 2;
    _photoView.layer.masksToBounds = YES;
    _photoView.image = [UIImage imageNamed:@"placeholder.png"];
    _photoView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectPhoto:)];
    [_photoView addGestureRecognizer:tap];
    [headerView addSubview:_photoView];
    
    UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(10,57,300, 1)];
    line1.backgroundColor = kColor(228, 228, 228, 1);
    [headerView addSubview:line1];
    
    UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, 60, 25)];
    lab2.backgroundColor = [UIColor clearColor];
    lab2.textColor = [UIColor blackColor];
    lab2.textAlignment = NSTextAlignmentLeft;
    lab2.font = [UIFont systemFontOfSize:14.0];
    lab2.text = @"昵称：";
    [headerView addSubview:lab2];
    
    _nameField = [[UITextField alloc] initWithFrame:CGRectMake(160, 70, 140, 25)];
    _nameField.borderStyle = UITextBorderStyleNone;
    _nameField.font = [UIFont systemFontOfSize:14];
    _nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _nameField.textAlignment = NSTextAlignmentRight;
    _nameField.text = _userInfo.name;
    _nameField.returnKeyType = UIReturnKeyDone;
    _nameField.delegate = self;
    [headerView addSubview:_nameField];
    
    UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(10,98,300,2)];
    line2.backgroundColor = kColor(228, 228, 228, 1);
    [headerView addSubview:line2];
    
    return headerView;
}

- (void)selectPhoto:(UITapGestureRecognizer *)tap {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"拍照",@"相册",nil];
    [sheet showInView:self.view];
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"user";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 130, 25)];
        titleLabel.tag = kTitleTag;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.textColor = [UIColor grayColor];
        [cell.contentView addSubview:titleLabel];
        
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 10, 170, 25)];
        contentLabel.tag = kContentTag;
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.textAlignment = NSTextAlignmentRight;
        contentLabel.font = [UIFont systemFontOfSize:14];
        contentLabel.textColor = [UIColor grayColor];
        [cell.contentView addSubview:contentLabel];
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(10,44, 300, 1)];
        line.backgroundColor = kColor(228, 228, 228, 1);
        [cell.contentView addSubview:line];
    }
    UILabel *title = (UILabel *)[cell.contentView viewWithTag:kTitleTag];
    UILabel *content = (UILabel *)[cell.contentView viewWithTag:kContentTag];
    switch (indexPath.row) {
        case 0: {
            title.text = @"行业认证：";
            content.text = _userInfo.lisence;
        }
            break;
        case 1: {
            title.text = @"课程类别：";
            content.text = _userInfo.publishClassType;
        }
            break;
        case 2: {
            title.text = @"手机号码：";
            content.text = _userInfo.mobilePhoneNum;
        }
            break;
        case 3: {
            title.text = @"邮箱：";
            content.text = _userInfo.email;
        }
            break;
        case 4: {
            title.text = @"生日：";
            content.text = _userInfo.birthday;
            
        }
            break;
        case 5: {
            title.text = @"性别：";
            content.text = @"男";
        }
            break;
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - TextField

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIActionSheet 

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"%d",buttonIndex);
    switch (buttonIndex) {
        case 0: {
            //拍照
            
        }
            break;
        case 1: {
            //相册
        }
            break;
        default:
            break;
    }
}

@end
