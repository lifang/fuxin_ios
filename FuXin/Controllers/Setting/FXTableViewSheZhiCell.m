//
//  FXTableViewSheZhiCell.m
//  FuXin
//
//  Created by SumFlower on 14-5-25.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXTableViewSheZhiCell.h"

@implementation FXTableViewSheZhiCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setlabel
{
    CALayer *layer = [self.count layer];
    [layer setCornerRadius:10.0];
    CALayer *layerimage = [self.backimage layer];
    [layerimage setCornerRadius:10.0];
//    self.hidden = NO;
}
@end
