//
//  FXUserSettingController.m
//  FuXin
//
//  Created by 徐宝桥 on 14-6-3.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXUserSettingController.h"
#import "FXRequestDataFormat.h"
#import "FXResizeImage.h"
#import "FXArchiverHelper.h"

#define kTitleTag       200
#define kContentTag     201

@interface FXUserSettingController ()<UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

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
    self.title = @"我的信息";
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 重写

- (void)rightBarTouched:(id)sender {
    FXAppDelegate *delegate = [FXAppDelegate shareFXAppDelegate];
    [FXRequestDataFormat changeProfileWithToken:delegate.token
                                         UserID:delegate.userID
                                      Signature:nil
                                          Tiles:UIImagePNGRepresentation(_photoView.image)
                                    ContentType:@"png"
                                       NickName:_nameField.text
                                       Finished:^(BOOL success, NSData *response) {
        NSString *info = @"";
        if (success) {
            //请求成功
            ChangeProfileResponse *resp = [ChangeProfileResponse parseFromData:response];
            if (resp.isSucceed) {
                //修改成功
                [self saveUserInfoWithNewProfile:resp.profile];
                info = @"修改个人信息成功";
            }
            else {
                //修改失败
                info = @"修改个人信息失败";
            }
        }
        else {
            //请求失败
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:info
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }];
}

- (void)saveUserInfoWithNewProfile:(Profile *)profile {
    FXUserModel *user = [[FXUserModel alloc] init];
    user.userID = [NSNumber numberWithInt:profile.userId];
    user.name = profile.name;
    user.nickName = profile.nickName;
    user.genderType = [NSNumber numberWithInt:profile.gender];
    user.mobilePhoneNum = profile.mobilePhoneNum;
    user.email = profile.email;
    user.birthday = profile.birthday;
    user.isProvider = [NSNumber numberWithBool:profile.isProvider];
    user.lisence = profile.lisence;
    user.tileURL = profile.tileUrl;
    FXAppDelegate *delegate = [FXAppDelegate shareFXAppDelegate];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        user.tile = UIImagePNGRepresentation(_photoView.image);
        [FXArchiverHelper saveUserInfo:user];
        delegate.user = user;
        dispatch_async(dispatch_get_main_queue(), ^{
           //更新用户信息通知
            [[NSNotificationCenter defaultCenter] postNotificationName:UpdateUserInfoNotification object:nil];
        });
    });
    
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
    
    _photoView = [[UIImageView alloc] initWithFrame:CGRectMake(260, 10, 40, 40)];
    _photoView.layer.cornerRadius = _photoView.frame.size.height / 2;
    _photoView.layer.masksToBounds = YES;
    if (_userInfo.tile && [_userInfo.tile length] > 1) {
        _photoView.image = [UIImage imageWithData:_userInfo.tile];
    }
    else {
        _photoView.image = [UIImage imageNamed:@"placeholder.png"];
    }
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
    _nameField.text = _userInfo.nickName;
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
    return 5;
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
//        case 1: {
//            title.text = @"课程类别：";
//        }
//            break;
        case 1: {
            title.text = @"手机号码：";
            content.text = _userInfo.mobilePhoneNum;
        }
            break;
        case 2: {
            title.text = @"邮箱：";
            content.text = _userInfo.email;
        }
            break;
        case 3: {
            title.text = @"生日：";
            content.text = _userInfo.birthday;
            
        }
            break;
        case 4: {
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
    NSInteger sourceType = UIImagePickerControllerSourceTypeCamera;
    switch (buttonIndex) {
        case 0: {
            //拍照
            sourceType = UIImagePickerControllerSourceTypeCamera;
        }
            break;
        case 1: {
            //相册
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
            break;
        default:
            break;
    }
    
    if ([UIImagePickerController isSourceTypeAvailable:sourceType] &&
        buttonIndex != actionSheet.cancelButtonIndex) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}

#pragma mark - UIImagePickerDelegate 

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *editImage = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *resizeImage = [FXResizeImage scaleImage:editImage];
    _photoView.image = resizeImage;
}

@end
