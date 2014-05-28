//
//  FXMyInfoViewController.m
//  FuXin
//
//  Created by SumFlower on 14-5-26.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXMyInfoViewController.h"

@interface FXMyInfoViewController ()<UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>

@end

@implementation FXMyInfoViewController

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
    self.title = @"我的信息";
    self.userNiChen.delegate = self;
    
    //导航栏左侧button
    UIButton *leftbt = [UIButton buttonWithType:UIButtonTypeCustom];
    leftbt.frame = CGRectMake(0, 0, 32, 32);
    [leftbt setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftbt addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithCustomView:leftbt];
    self.navigationItem.leftBarButtonItem = left;
    //头像圆角
    CALayer *layer = [self.userImage layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:25.0];
    [layer setBorderWidth:1.0];
    [layer setBorderColor:[[UIColor blackColor] CGColor]];    

    // Do any additional setup after loading the view from its nib.
}
#pragma mark--textfield代理方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"结束编辑");
    NSMutableString *tempUrl = nil;//接口
    
}

-(void)backView
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)changeHeaderAction:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相机" otherButtonTitles:@"图库", nil];
    sheet.tag = 1;
    [sheet showInView:self.view];
}

#pragma mark--actionSheet代理方法
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        if (buttonIndex == 0) {
            if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"本设备不支持拍照" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            return;
        }
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
       }else{
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }
        imagePicker.allowsEditing = YES;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }else{
        if (buttonIndex == 0) {
            //保存图片
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"更新成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
    }

}

#pragma mark--UIAlertView代理方法
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark--imagePickerController代理方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *newImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    self.userImage.imageView.image = newImage;
    UIActionSheet *sheet2 = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定上传" otherButtonTitles: nil];
    sheet2.tag = 2;
    UIWindow *window = [[[UIApplication sharedApplication]delegate] window];
    if ([window.subviews containsObject:self.view]) {
        [sheet2 showInView:self.view];
    }else{
        [sheet2 showInView:window];
    }
}
@end
