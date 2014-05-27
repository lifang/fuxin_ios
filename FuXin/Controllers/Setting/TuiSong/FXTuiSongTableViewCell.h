//
//  FXTuiSongTableViewCell.h
//  FuXin
//
//  Created by SumFlower on 14-5-25.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//
@protocol FXTuiSongTableViewCellDelegate <NSObject>

@optional
-(void)switchClick:(id)sender;

@end
#import <UIKit/UIKit.h>

@interface FXTuiSongTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *tuiSongTitle;
@property (weak, nonatomic) IBOutlet UISwitch *tuiSongSwitch;
@property (weak, nonatomic) id<FXTuiSongTableViewCellDelegate>delegate;
-(void)switchEvent;
@end
