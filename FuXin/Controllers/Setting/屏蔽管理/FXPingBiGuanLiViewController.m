//
//  FXPingBiGuanLiViewController.m
//  FuXin
//
//  Created by SumFlower on 14-5-26.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXPingBiGuanLiViewController.h"
#import "FXPingBiTableViewCell.h"
#import "FXAlterView.h"
@interface FXPingBiGuanLiViewController ()<UITableViewDataSource,UITableViewDelegate,FXPingBiTableViewCellDelegate>

@end

@implementation FXPingBiGuanLiViewController

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
    self.title = @"屏蔽管理";
    self.myTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.myTable];
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        UINib *nib = [UINib nibWithNibName:@"FXPingBiTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:ID];
    }
    FXPingBiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[FXPingBiTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    [cell initButton];
    cell.delegate = self;
    cell.userName.text = @"拉布拉多";
    cell.userImage.image =[UIImage imageNamed:@"user"];
    return cell;
    
}
-(void)didHuiFu
{
    NSLog(@"点击恢复");
    //添加并设置view
    CGRect rect = self.view.frame;
    UIView *view = [[UIView alloc]init];
    UIColor *backcolor = [UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:0.5];
    view.frame = rect;
    view.backgroundColor = backcolor;
    [self.view addSubview:view];
//    FXForAlterViewController *Alter = [[FXForAlterViewController alloc]init];
//    Alter.view.frame = CGRectMake(17, 100, 280, 81);
//    
    FXAlterView *alterView = [[FXAlterView alloc]initWithFrame:CGRectMake(17, 100, 280, 81)];
    [alterView initWithView];
    alterView.userName.text = @"张同学";
    alterView.userWebName.text = @"张三三";
    alterView.userSex.image = [UIImage imageNamed:@"男"];
    [alterView.renZhenOneBt setImage:[UIImage imageNamed:@"ICON_03"] forState:UIControlStateNormal];
    [alterView.renZhenTwoBt setImage:[UIImage imageNamed:@"2_05"] forState:UIControlStateNormal];
    [self.view insertSubview:alterView aboveSubview:view];

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
