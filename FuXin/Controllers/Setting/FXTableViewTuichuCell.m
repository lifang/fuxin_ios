//
//  FXTableViewTuichuCell.m
//  FuXin
//
//  Created by SumFlower on 14-5-25.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXTableViewTuichuCell.h"

@implementation FXTableViewTuichuCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)addCellbutton
{
    
    [self.tuiChu addTarget:self action:@selector(tuichuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)tuichuButtonClick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(buttonclick)]) {
        [self.delegate buttonclick];
    }
}
@end
