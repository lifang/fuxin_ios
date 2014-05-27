//
//  FXTuiSongTableViewCell.m
//  FuXin
//
//  Created by SumFlower on 14-5-25.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXTuiSongTableViewCell.h"

@implementation FXTuiSongTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)switchEvent
{
    [self.tuiSongSwitch addTarget:self action:@selector(clickAc:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)clickAc:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(switchClick:)]) {
        [self.delegate switchClick:(id)sender];
    }
}
@end
