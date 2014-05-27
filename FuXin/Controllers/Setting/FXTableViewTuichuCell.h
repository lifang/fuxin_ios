//
//  FXTableViewTuichuCell.h
//  FuXin
//
//  Created by SumFlower on 14-5-25.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//
@protocol FXTableViewTuichuCellDelegate <NSObject>

@required
-(void)buttonclick;
@end
#import <UIKit/UIKit.h>
@interface FXTableViewTuichuCell : UITableViewCell
@property (strong,nonatomic)id<FXTableViewTuichuCellDelegate>delegate;
@property (weak,nonatomic)IBOutlet UIButton *tuiChu;
-(void)tuichuButtonClick:(id)sender;
-(void)addCellbutton;
@end
