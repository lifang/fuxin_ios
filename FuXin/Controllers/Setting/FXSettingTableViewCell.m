//
//  FXSettingTableViewCell.m
//  FuXin
//
//  Created by SumFlower on 14-5-24.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXSettingTableViewCell.h"

@implementation FXSettingTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)initCellImage
{
    CALayer *layer = [self.userImage layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:35.0];
    [layer setBorderWidth:1];
    [layer setBorderColor:[[UIColor blackColor]CGColor]];
}
@end
