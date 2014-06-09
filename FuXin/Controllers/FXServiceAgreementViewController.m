//
//  FXServiceAgreementViewController.m
//  FuXin
//
//  Created by lihongliang on 14-6-4.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#define kBlankSize 15
static NSString *kServiceURL = @"https://118.242.18.189/resource/static/public/doc/app%20agreement.html";

#import "FXServiceAgreementViewController.h"


@interface FXServiceAgreementViewController ()
@property (strong ,nonatomic) UIWebView *webView;
@property (assign ,nonatomic) BOOL isAuthed;
@property (strong ,nonatomic) NSURLRequest *originRequest;
@end

@implementation FXServiceAgreementViewController

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
    self.view.backgroundColor = kColor(250, 250, 250, 1);
    
    self.webView = [[UIWebView alloc] init];
    _webView.frame = CGRectMake(kBlankSize, kBlankSize, 320 - kBlankSize, 560);
    _webView.backgroundColor = kColor(250, 250, 250, 1);
    
    [self.view addSubview:_webView];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:kServiceURL]]];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:kServiceURL]];
    [request setValidatesSecureCertificate:NO];
    request.defaultResponseEncoding = NSUTF8StringEncoding;
    request.delegate = self;
    [request startAsynchronous];
    
    
    [self setLeftNavBarItemWithImageName:@"back.png"];
    self.title = @"服务协议";
}

- (void)viewWillAppear:(BOOL)animated{
    _webView.frame = (CGRect){0 ,0 , self.view.frame.size};
    [_webView setNeedsLayout];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ASIHTTPRequest Delegate
- (void) requestFinished:(ASIHTTPRequest *)request{
    if (!request.error) {
        NSString *str = [NSString stringWithCString:[request.responseString UTF8String] encoding:NSUTF8StringEncoding];
        NSString *jsString = [NSString stringWithFormat:@"<html> \n"
                              "<head> \n"
                              "<style type=\"text/css\"> \n"
                              "body {font-size: %f; font-family: \"%@\"; color: %@;}\n"
                              "</style> \n"
                              "</head> \n"
                              "<body>%@</body> \n"
                              "</html>", 10., @"UTF-8", @"#333333", str];
        NSLog(@"%@",str);
        [_webView loadHTMLString:jsString baseURL:nil];
    }else{
        [FXAppDelegate errorAlert:@"请求出错,请稍后再试"];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request{
    [FXAppDelegate errorAlert:@"请求出错,请稍后再试"];
}

@end
