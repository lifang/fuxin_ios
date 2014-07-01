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
#import "FXDetailImageView.h"

#define kTitleTag       200
#define kContentTag     201

@interface FXUserSettingController ()<UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UIImageView *photoView;
@property (nonatomic, strong) UITextField *nameField;

@property (nonatomic, assign) BOOL isRequest;

@end

@implementation FXUserSettingController

@synthesize userInfo = _userInfo;
@synthesize photoView = _photoView;
@synthesize nameField = _nameField;
@synthesize userTableView = _userTableView;
@synthesize isRequest = _isRequest;

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

- (void)viewDidAppear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"userInfo"];

}

- (void)viewDidDisappear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"userInfo"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 重写

- (void)rightBarTouched:(id)sender {
    if (!_isRequest) {
        _isRequest = YES;
        FXAppDelegate *delegate = [FXAppDelegate shareFXAppDelegate];
        [FXRequestDataFormat
         changeProfileWithToken:delegate.token UserID:delegate.userID
         Signature:nil
         Tiles:UIImageJPEGRepresentation(_photoView.image, 1.0)
         ContentType:@"jpg"
         NickName:_nameField.text
         Finished:^(BOOL success, NSData *response) {
             _isRequest = NO;
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
    user.isAuth = [NSNumber numberWithBool:profile.isAuthentication];
    user.fuzhi = profile.fuzhi;
    FXAppDelegate *delegate = [FXAppDelegate shareFXAppDelegate];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        user.tile = UIImageJPEGRepresentation(_photoView.image, 1.0);
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
    UIView *view = [[UIView alloc] initWithFrame:_userTableView.bounds];
    view.backgroundColor = kColor(239, 239, 244, 1);
    _userTableView.backgroundView = view;
    if (kDeviceVersion >= 7.0) {
        _userTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    [self hiddenExtraCellLineWithTableView:_userTableView];
    [self.view addSubview:_userTableView];
    
    _photoView = [[UIImageView alloc] init];
    _nameField = [[UITextField alloc] init];
}

- (void)hiddenExtraCellLineWithTableView:(UITableView *)table {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [table setTableFooterView:view];
}

- (void)selectPhoto:(UITapGestureRecognizer *)tap {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"拍照",@"相册",nil];
    [sheet showInView:self.view];
}

- (void)showBigImage:(UITapGestureRecognizer *)tap {
    _userTableView.userInteractionEnabled = NO;
    FXDetailImageView *bigView = [[FXDetailImageView alloc] initWithFrame:CGRectMake(0, 0, 320, kScreenHeight)];
    bigView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    bigView.saveBtn.hidden = YES;
    bigView.progressView.hidden = YES;
    [UIView animateWithDuration:0.3f animations:^{
        bigView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finish) {
        _userTableView.userInteractionEnabled = YES;
    }];
    [self.view.window addSubview:bigView];
    if (_userInfo.tile && [_userInfo.tile length] > 1) {
        [bigView setBigImageWithData:_userInfo.tile];
    }
    else {
        UIImage *placeImage = [UIImage imageNamed:@"placeholder.png"];
        [bigView setBigImageWithImage:placeImage];
    }
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0: {
            return 2;
        }
            break;
        case 1: {
            if ([_userInfo.isProvider boolValue]) {
                return 6;
            }
            return 5;
        }
            break;
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, cell.bounds.size.height)];
        titleLabel.tag = kTitleTag;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textColor = [UIColor grayColor];
        [cell.contentView addSubview:titleLabel];
        
        if (indexPath.section == 0) {
            switch (indexPath.row) {
                case 0: {
                    _photoView.frame = CGRectMake(240, 10, 60, 60);
                    _photoView.layer.cornerRadius = _photoView.frame.size.height / 2;
                    _photoView.layer.masksToBounds = YES;
                    _photoView.userInteractionEnabled = YES;
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBigImage:)];
                    [_photoView addGestureRecognizer:tap];
                    [cell.contentView addSubview:_photoView];
                }
                    break;
                case 1: {
                    _nameField.frame = CGRectMake(160, 13, 140, 25);
                    _nameField.borderStyle = UITextBorderStyleNone;
                    _nameField.font = [UIFont systemFontOfSize:15];
                    _nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
                    _nameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                    _nameField.textAlignment = NSTextAlignmentRight;
                    _nameField.returnKeyType = UIReturnKeyDone;
                    _nameField.delegate = self;
                    [cell.contentView addSubview:_nameField];
                }
                    break;
                default:
                    break;
            }
        }
        else {
            UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 10, 170, 25)];
            contentLabel.tag = kContentTag;
            contentLabel.backgroundColor = [UIColor clearColor];
            contentLabel.textAlignment = NSTextAlignmentRight;
            contentLabel.font = [UIFont systemFontOfSize:15];
            contentLabel.textColor = [UIColor grayColor];
            [cell.contentView addSubview:contentLabel];
        }
        if (kDeviceVersion < 7.0) {
            UIView *view = [[UIView alloc] initWithFrame:cell.bounds];
            view.backgroundColor = [UIColor whiteColor];
            cell.backgroundView = view;
        }
    }
    UILabel *title = (UILabel *)[cell.contentView viewWithTag:kTitleTag];
    UILabel *content = (UILabel *)[cell.contentView viewWithTag:kContentTag];
    title.frame = CGRectMake(10, 0, 120, 50);
    content.frame = CGRectMake(110, 0, 190, 50);
    content.numberOfLines = 2;
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0: {
                    title.frame = CGRectMake(10, 0, 100, 80);
                    title.textColor = [UIColor blackColor];
                    title.text = @"头       像";
                    if (_userInfo.tile && [_userInfo.tile length] > 1) {
                        _photoView.image = [UIImage imageWithData:_userInfo.tile];
                    }
                    else {
                        _photoView.image = [UIImage imageNamed:@"placeholder.png"];
                    }
                }
                    break;
                case 1: {
                    title.textColor = [UIColor blackColor];
                    title.text = @"昵       称";
                    _nameField.text = _userInfo.nickName;
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1: {
            if ([_userInfo.isProvider boolValue]) {
                switch (indexPath.row) {
                    case 0: {
                        title.text = @"福       指：";
                        content.text = _userInfo.fuzhi;
                    }
                        break;
                    case 1: {
                        title.text = @"行业认证：";
                        content.text = _userInfo.lisence;
                    }
                        break;
                    case 2: {
                        title.text = @"手机号码：";
                        content.text = _userInfo.mobilePhoneNum;
                    }
                        break;
                    case 3: {
                        title.text = @"邮       箱：";
                        content.text = _userInfo.email;
                    }
                        break;
                    case 4: {
                        title.text = @"生       日：";
                        content.text = _userInfo.birthday;
                    }
                        break;
                    case 5: {
                        title.text = @"性       别：";
                        if ([_userInfo.genderType intValue] == 0) {
                            content.text = @"男";
                        }
                        else if ([_userInfo.genderType intValue] == 1) {
                            content.text = @"女";
                        }
                        else {
                            content.text = @"保密";
                        }
                    }
                        break;
                    default:
                        break;
                }
                
            }
            else {
                switch (indexPath.row) {
                    case 0: {
                        title.text = @"行业认证：";
                        content.text = _userInfo.lisence;
                    }
                        break;
                    case 1: {
                        title.text = @"手机号码：";
                        content.text = _userInfo.mobilePhoneNum;
                    }
                        break;
                    case 2: {
                        title.text = @"邮       箱：";
                        content.text = _userInfo.email;
                    }
                        break;
                    case 3: {
                        title.text = @"生       日：";
                        content.text = _userInfo.birthday;
                        
                    }
                        break;
                    case 4: {
                        title.text = @"性       别：";
                        if ([_userInfo.genderType intValue] == 0) {
                            content.text = @"男";
                        }
                        else if ([_userInfo.genderType intValue] == 1) {
                            content.text = @"女";
                        }
                        else {
                            content.text = @"保密";
                        }
                    }
                        break;
                    default:
                        break;
                }
            }
        }
            break;
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 80;
    }
    else {
        return 50;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0: {
                    [self selectPhoto:nil];
                }
                    break;
                case 1: {
                    [_nameField becomeFirstResponder];
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
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 15)];
    view.backgroundColor = [UIColor clearColor];
    return view;
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
