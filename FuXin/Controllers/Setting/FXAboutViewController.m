//
//  FXAboutViewController.m
//  FuXin
//
//  Created by 徐宝桥 on 14-8-26.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXAboutViewController.h"

@interface FXAboutViewController ()

@end

@implementation FXAboutViewController

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
    self.title = @"关于我们";
    [self setLeftNavBarItemWithImageName:@"back.png"];
    UIWebView *webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, kScreenHeight - 64 - 49)];
    [webview loadHTMLString:@"<p style=\"text-indent: 2em\">福务网（fuwu.com）致力于打造全球最大的知识、信息、资讯等无形服务的传递、传授平台，使无形/软性服务的传递、传授突破空间的限制，让所有的无 形服务触手可及，降低无形的服务传递、传授的时间成本和空间成本，进而降低资源浪费；方便人们对各类知识、信息、资讯的获取，提高人们对知识的尊重和价值 认可，提高人们学习进取的积极性，进而改善人们的生活习惯，提升全民族的精神素养，为创建和谐社会提供重要的物质基础。</p> <p style=\"text-indent: 2em\">手机端《福务网》是上海知是网络为用户提供的以通讯功能为主的APP。帮助福师在手机上与福客进行沟通，并辅助其推广福务。</p>福务网福务电话：400-000-5555<br/>工作时间：24小时（法定节假日除外）<br/>邮箱：service@fuwu.com" baseURL:nil];
    [self.view addSubview:webview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
