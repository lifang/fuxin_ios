//
//  FXNotificationContentViewController.m
//  FuXin
//
//  Created by lihongliang on 14-6-4.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXNotificationContentViewController.h"

#define kBlankSize 15

@interface FXNotificationContentViewController ()
@property (strong ,nonatomic)UIWebView *webView;
@end

@implementation FXNotificationContentViewController

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
    self.title = @"系统公告";
    [self setRightNavBarItemWithImageName:@"rubbish.png"];
}

- (void)viewWillAppear:(BOOL)animated{
    UIWebView *webView = [[UIWebView alloc] init];
    webView.backgroundColor = [UIColor clearColor];
    webView.frame = CGRectMake(kBlankSize, kBlankSize, 320 - 2 * kBlankSize, self.view.frame.size.height - kBlankSize);
    [self.view addSubview:webView];
    self.webView = webView;
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
