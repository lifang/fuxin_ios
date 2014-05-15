//
//  TestViewController.m
//  FuXin
//
//  Created by lihongliang on 14-5-14.
//  Copyright (c) 2014年 comdosoft. All rights reserved.
//

#import "TestViewController.h"
#import "FMDB.h"

@interface TestViewController ()
@property (weak, nonatomic) IBOutlet UITextField *inputTextView;
@property (weak, nonatomic) IBOutlet UITextView *outputTextView;
@property (weak, nonatomic) IBOutlet UITextField *outputTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *convertButton;

@end

@implementation TestViewController

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
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.convertButton addTarget:self action:@selector(convertButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)convertButtonClicked:(id)sender{
    NSInteger i = self.inputTextView.text.integerValue;
    
    NSString *unicodeString = [NSString stringWithFormat:@"%C",(unsigned short)i];
    self.outputTextField.text = unicodeString;
    self.outputTextView.text = unicodeString;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1334;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    for (id view in cell.contentView.subviews) {
        if ([view isKindOfClass:[UITextField class]]) {
            [view removeFromSuperview];
        }
    }
    UITextField *textField = [[UITextField alloc] initWithFrame:cell.contentView.frame];
    int i = 57345 + (int)indexPath.row;
    
    NSString *unicodeString = [NSString stringWithFormat:@"%C",(unsigned short)i];
    textField.text = [NSString stringWithFormat:@"%@  = %d",unicodeString,i];
    [cell.contentView addSubview:textField];
    return cell;
}

@end
