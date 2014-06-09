//
//  FXServiceAgreementViewController.m
//  FuXin
//
//  Created by lihongliang on 14-6-4.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#define kBlankSize 15

#import "FXServiceAgreementViewController.h"


@interface FXServiceAgreementViewController ()
@property (strong ,nonatomic) UITextView *textView;
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
    
    self.textView = [[UITextView alloc] init];
    _textView.frame = CGRectMake(kBlankSize, kBlankSize, 320 - kBlankSize, 560);
    _textView.backgroundColor = kColor(250, 250, 250, 1);
    _textView.font = [UIFont systemFontOfSize:13.];
    _textView.selectable = NO;
    _textView.textColor = kColor(51, 51, 51, 1);
    [self.view addSubview:_textView];
    
    _textView.text = [NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"haha" withExtension:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    [self setLeftNavBarItemWithImageName:@"back.png"];
    self.title = @"服务协议";
}

- (void)viewWillAppear:(BOOL)animated{
    _textView.frame = (CGRect){0 ,0 , self.view.frame.size};
    _textView.contentOffset = CGPointMake(0, 0);
    _textView.textContainerInset = UIEdgeInsetsMake(15, 15, 0, 15);
    [_textView setNeedsLayout];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
