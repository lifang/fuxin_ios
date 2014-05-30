//
//  FXSettingTableViewCell.m
//  FuXin
//
//  Created by SumFlower on 14-5-24.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXSettingTableViewCell.h"
#import "FXUtility.h"

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
    [layer setCornerRadius:25.0];
    [layer setBorderWidth:1];
    [layer setBorderColor:[[UIColor blackColor]CGColor]];
}
/*
- (void)layoutSubviews{
    CGSize size = [FXUtility getTextSizeWithString:self.userName.text withFont:self.userName.font withWidth:120];
    self.userName.frame = CGRectMake(self.userName.frame.origin.x, self.userName.frame.origin.y, size.width, self.userName.frame.size.height);
    
    self.userSex.frame = (CGRect){CGRectGetMaxX(self.userName.frame) + 20 ,self.userSex.frame.origin.y,self.userSex.frame.size};
}*/
@end
