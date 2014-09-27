//
//  FXUserInfoController.m
//  FuXin
//
//  Created by 徐宝桥 on 14-7-17.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXUserInfoController.h"
#import "FXInfoHeaderView.h"
#import "FXResizeImage.h"
#import "FXArchiverHelper.h"
#import "FXDetailImageView.h"
#import "FXModifyController.h"
#import "FXFileHelper.h"

#define kUserTitleTag   1200
#define kUserContentTag 1201

#define kAuthUserFirstTag   1500

@interface FXUserInfoController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) FXInfoHeaderView *headerView;

@property (nonatomic, assign) BOOL isRequest;

//认证三个小图标
@property (nonatomic, strong) UIImageView *authView1;

@property (nonatomic, strong) UIImageView *authView2;

@property (nonatomic, strong) UIImageView *authView3;

@end

@implementation FXUserInfoController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

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
    self.title = @"我的信息";
    [self setLeftNavBarItemWithImageName:@"back.png"];
    FXAppDelegate *delegate = [FXAppDelegate shareFXAppDelegate];
    if (delegate.user) {
        _userInfo = delegate.user;
    }
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    FXAppDelegate *delegate = [FXAppDelegate shareFXAppDelegate];
    if (delegate.user) {
        _userInfo = delegate.user;
    }
    [_headerView setUser:_userInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)initUI {
    _userTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, kScreenHeight - 64) style:UITableViewStylePlain];
    _userTableView.delegate = self;
    _userTableView.dataSource = self;
    if (kDeviceVersion >= 7.0) {
        _userTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    [self initHeaderView];
    [self hiddenExtraCellLineWithTableView:_userTableView];
    [self.view addSubview:_userTableView];
    
    _authView1 = [[UIImageView alloc] init];
    _authView2 = [[UIImageView alloc] init];
    _authView3 = [[UIImageView alloc] init];
}

- (void)initHeaderView {
    _headerView = [[FXInfoHeaderView alloc] initWithFrame:CGRectMake(0, 0, 320, 150)];
    _headerView.photoView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchPhoto)];
    [_headerView.photoView addGestureRecognizer:tap];
    _userTableView.tableHeaderView = _headerView;
//    [_headerView setUser:_userInfo];
    
    UITapGestureRecognizer *modifyTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(modifyNickName)];
    _headerView.detailLabel.userInteractionEnabled = YES;
    [_headerView.detailLabel addGestureRecognizer:modifyTap];
    [_headerView.modifyBtn addTarget:self action:@selector(modifyNickName) forControlEvents:UIControlEventTouchUpInside];
}

- (void)hiddenExtraCellLineWithTableView:(UITableView *)table {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [table setTableFooterView:view];
}

- (void)modifyPhotoWithImage:(UIImage *)image {
    if (!_isRequest) {
        _isRequest = YES;
        FXAppDelegate *delegate = [FXAppDelegate shareFXAppDelegate];
        [FXRequestDataFormat
         changeProfileWithToken:delegate.token UserID:delegate.userID
         Signature:nil
         Tiles:UIImageJPEGRepresentation(image, 1.0)
         ContentType:@"jpg"
         NickName:nil
         Finished:^(BOOL success, NSData *response) {
             _isRequest = NO;
             NSString *info = @"";
             if (success) {
                 //请求成功
                 ChangeProfileResponse *resp = [ChangeProfileResponse parseFromData:response];
                 if (resp.isSucceed) {
                     //修改成功
                     [self saveUserInfoWithNewProfile:resp.profile];
                     _headerView.photoView.image = image;
                     info = @"修改个人信息成功";
                 }
                 else {
                     //修改失败
                     info = @"修改个人信息失败";
                     if (!self.errorHandler) {
                         self.errorHandler = [[FXReuqestError alloc] init];
                     }
                     [self.errorHandler requestDidFailWithErrorCode:resp.errorCode];
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
    user.nickName = _userInfo.nickName;
    user.genderType = [NSNumber numberWithInt:profile.gender];
    user.mobilePhoneNum = profile.mobilePhoneNum;
    user.email = profile.email;
    user.birthday = profile.birthday;
    user.isProvider = [NSNumber numberWithBool:profile.isProvider];
    user.lisence = profile.lisence;
    user.tileURL = profile.tileUrl;
    user.isAuth = [NSNumber numberWithBool:profile.isAuthentication];
    user.fuzhi = profile.fuzhi;
    user.location = profile.location;
    user.description = profile.description;
    user.licences = profile.licensesList;
    FXAppDelegate *delegate = [FXAppDelegate shareFXAppDelegate];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        user.tile = UIImageJPEGRepresentation(_headerView.photoView.image, 1.0);
        [FXArchiverHelper saveUserInfo:user];
        delegate.user = user;
        _userInfo = user;
        dispatch_async(dispatch_get_main_queue(), ^{
            //更新用户信息通知
            [[NSNotificationCenter defaultCenter] postNotificationName:UpdateUserInfoNotification object:nil];
        });
    });
}

#pragma mark - Action

- (void)touchPhoto {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@""
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"查看头像",@"相册上传",@"拍照上传",nil];
    [sheet showInView:self.view];
}

- (void)modifyNickName {
    FXModifyController *modifyController = [[FXModifyController alloc] init];
    modifyController.type = ModifyUser;
    modifyController.userInfo = _userInfo;
    [self.navigationController pushViewController:modifyController animated:YES];
}

- (void)showBigImage {
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

#pragma mark - download

- (void)showAuthForCell:(UITableViewCell *)cell withDataArray:(NSArray *)item {
    CGFloat originX = 280;
    for (int i = [item count] - 1; i >= 0; i--) {
        FXUserLicence *licence = [item objectAtIndex:i];
        NSLog(@"%@,%@,%@",licence.name,licence.iconURL,licence.order);
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(originX, 10, 24, 24)];
        imageView.tag = kAuthUserFirstTag + i;
        [cell.contentView addSubview:imageView];
        [self downloadImageForImageView:imageView withURL:licence.iconURL];
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

#pragma mark - UIActionSheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSInteger sourceType = UIImagePickerControllerSourceTypeCamera;
    switch (buttonIndex) {
        case 0: {
            //查看大图
            [self showBigImage];
            return;
        }
            break;
        case 1: {
            //相册
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
            break;
        case 2: {
            //拍照
            sourceType = UIImagePickerControllerSourceTypeCamera;
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
//    _headerView.photoView.image = resizeImage;
    [self modifyPhotoWithImage:resizeImage];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (![_userInfo.isProvider boolValue]) {
        return 5;
    }
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 80, 25)];
        titleLabel.tag = kUserTitleTag;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = [UIFont boldSystemFontOfSize:14];
        titleLabel.textColor = [UIColor blackColor];
        [cell.contentView addSubview:titleLabel];
        
        if (indexPath.row == 0) {
            _authView1.frame = CGRectMake(220, 12, 20, 20);
            _authView1.image = [UIImage imageNamed:@"auth1.png"];
            [cell.contentView addSubview:_authView1];
            
            _authView2.frame = CGRectMake(250, 12, 20, 20);
            _authView2.image = [UIImage imageNamed:@"auth2.png"];
            [cell.contentView addSubview:_authView2];
            
            _authView3.frame = CGRectMake(280, 12, 20, 20);
            _authView3.image = [UIImage imageNamed:@"auth3.png"];
            [cell.contentView addSubview:_authView3];
        }
        else {
            UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(95, 3, 203, 40)];
            contentLabel.tag = kUserContentTag;
            contentLabel.backgroundColor = [UIColor clearColor];
            contentLabel.textAlignment = NSTextAlignmentRight;
            contentLabel.font = [UIFont systemFontOfSize:13];
            contentLabel.textColor = [UIColor grayColor];
            [cell.contentView addSubview:contentLabel];
        }
    }
    UILabel *title = (UILabel *)[cell.contentView viewWithTag:kUserTitleTag];
    UILabel *content = (UILabel *)[cell.contentView viewWithTag:kUserContentTag];
    switch (indexPath.row) {
        case 0: {
            title.text = @"认证";
            if ([_userInfo.isAuth boolValue]) {
                _authView1.image = [UIImage imageNamed:@"auth1_selected.png"];
            }
            if (_userInfo.email && ![_userInfo.email isEqualToString:@""]) {
                _authView2.image = [UIImage imageNamed:@"auth2_selected.png"];
            }
            if (_userInfo.mobilePhoneNum && ![_userInfo.mobilePhoneNum isEqualToString:@""]) {
                _authView3.image = [UIImage imageNamed:@"auth3_selected.png"];
            }
        }
            break;
        case 1: {
            title.text = @"邮箱";
            content.text = _userInfo.email;
        }
            break;
        case 2: {
            title.text = @"手机号码";
            content.text = _userInfo.mobilePhoneNum;
        }
            break;
        case 3: {
            title.text = @"生日";
            content.text = _userInfo.birthday;
        }
            break;
        case 4: {
            title.text = @"所在地";
            content.text = _userInfo.location;
        }
            break;
        case 5: {
            title.text = @"认证行业";
            content.hidden = YES;
            [self showAuthForCell:cell withDataArray:_userInfo.licences];
//            content.text = _userInfo.lisence;
        }
            break;
        case 6: {
            title.text = @"福指";
            content.text = _userInfo.fuzhi;
        }
            break;
        case 7: {
            CGSize size = [_userInfo.description sizeWithFont:[UIFont systemFontOfSize:13]
                                            constrainedToSize:CGSizeMake(215, CGFLOAT_MAX)];
            size.height = size.height < 44 ? 44 : size.height;
            title.frame = CGRectMake(15, 5, 80, size.height);
            
            title.text = @"福师简介";
            content.textAlignment = NSTextAlignmentRight;
            content.numberOfLines = 0;
            content.frame = CGRectMake(85, 5, 215, size.height);
            content.text = _userInfo.description;
        }
            break;
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 7) {
        CGSize size = [_userInfo.description sizeWithFont:[UIFont systemFontOfSize:13]
                                        constrainedToSize:CGSizeMake(215, CGFLOAT_MAX)];
        size.height = size.height < 44 ? 44 : size.height;
        //上下偏移量各5
        return size.height + 10;
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
