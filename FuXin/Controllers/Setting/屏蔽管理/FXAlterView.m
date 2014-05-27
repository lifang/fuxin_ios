//
//  FXAlterView.m
//  FuXin
//
//  Created by SumFlower on 14-5-26.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXAlterView.h"

@implementation FXAlterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        CALayer *viewlayer = [self layer];
        [viewlayer setCornerRadius:5];
        // Initialization code
    }
    return self;
}
-(void)initWithView
{
    //button
     self.confirmBt = [UIButton buttonWithType:UIButtonTypeCustom];
    self.confirmBt.frame = CGRectMake(0, 51, 280, 30);
    [self.confirmBt setTitle:@"恢复到通讯录" forState:UIControlStateNormal];
    [self.confirmBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.confirmBt addTarget:self action:@selector(btAction) forControlEvents:UIControlEventTouchUpInside];
    //button颜色
    UIColor *btcolor = [UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:.5];
    self.confirmBt.backgroundColor = btcolor;
    [self addSubview:self.confirmBt];
    
    //userimage
    self.userImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 9, 40, 40)];
    self.userImage.image = [UIImage imageNamed:@"user"];
    [self addSubview:self.userImage];
    
    //用户名
    self.userName = [[UILabel alloc]initWithFrame:CGRectMake(65, 7, 50, 21)];
    [self.userName setFont:[UIFont fontWithName:nil size:15.0]];
    [self addSubview:self.userName];
    
    //用户网络名
    self.userWebName = [[UILabel alloc]initWithFrame:CGRectMake(65, 33, 42, 21)];
    [self.userWebName setFont:[UIFont fontWithName:nil size:13.0]];
    self.userWebName.textColor = [UIColor lightGrayColor];
    [self addSubview:self.userWebName];
    
    //用户性别图片
    self.userSex = [[UIImageView alloc]initWithFrame:CGRectMake(120, 6, 15, 15)];
    [self addSubview:self.userSex];
    
    //认证图片
    self.renZhenOneBt = [[UIButton alloc]initWithFrame:CGRectMake(185, 6, 30, 20)];
    self.renZhenTwoBt = [[UIButton alloc]initWithFrame:CGRectMake(227, 6, 30, 20)];
    [self addSubview:self.renZhenTwoBt];
    [self addSubview:self.renZhenOneBt];

}
-(void)btAction
{
    NSLog(@"确认恢复");
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
