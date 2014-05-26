//
//  FXTuiSongViewController.m
//  FuXin
//
//  Created by SumFlower on 14-5-25.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXTuiSongViewController.h"
#import "FXTuiSongTableViewCell.h"
@interface FXTuiSongViewController ()<UITableViewDataSource,UITableViewDelegate,FXTuiSongTableViewCellDelegate>

@end

@implementation FXTuiSongViewController

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
    self.title = @"消息推送";
    self.TuiSongTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 22, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.TuiSongTable];
    self.TuiSongTable.delegate = self;
    self.TuiSongTable.dataSource = self;
    
    // Do any additional setup after loading the view.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"id";
    static BOOL nibRegister = NO;
    if (!nibRegister) {
        UINib *nib = [UINib nibWithNibName:@"FXTuiSongTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:ID];
    }
    FXTuiSongTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell =[[FXTuiSongTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    if (indexPath.row == 0) {
        cell.tuiSongTitle.text = @"消息主动推送";
        cell.tuiSongSwitch.tag = 0;
    }else if (indexPath.row == 1){
        cell.tuiSongTitle.text = @"消息提示音";
        cell.tuiSongSwitch.tag = 1;
    }else{
        cell.tuiSongTitle.text = @"消息震动";
        cell.tuiSongSwitch.tag = 2;
    }
    cell.delegate = self;
    [cell switchEvent];
    [self setTableViewFootWhite];
    return cell;
}
-(void)switchClick:(id)sender
{
    UISwitch *switchButton = (UISwitch *)sender;
    //通过tag判断switch
    if (switchButton.on == YES) {
        NSLog(@"ON");
    }else
        NSLog(@"OFF");
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setTableViewFootWhite
{
    UIView *view = [[UIView alloc]init];
    [view setBackgroundColor:[UIColor clearColor]];
    [self.TuiSongTable setTableFooterView:view];
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
