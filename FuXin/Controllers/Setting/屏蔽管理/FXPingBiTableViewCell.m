//
//  FXPingBiTableViewCell.m
//  FuXin
//
//  Created by SumFlower on 14-5-26.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXPingBiTableViewCell.h"

@implementation FXPingBiTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)initButton
{
    CALayer *layer = [self.userImage layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:17.0];
    [layer setBorderWidth:1.0];
    [layer setBorderColor:[[UIColor blackColor]CGColor]];
    self.huiFuBt.layer.masksToBounds = YES;
    self.huiFuBt.layer.borderWidth = 1.0;
    self.huiFuBt.layer.cornerRadius = 10.0;
//    self.huiFuBt = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.huiFuBt addTarget:self action:@selector(btAcEvent) forControlEvents:UIControlEventTouchUpInside];
}
-(void)btAcEvent
{
    if ([self.delegate respondsToSelector:@selector(didHuiFu)]) {
        [self.delegate didHuiFu];
    }
}
@end
