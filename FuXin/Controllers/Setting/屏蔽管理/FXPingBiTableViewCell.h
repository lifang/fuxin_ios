//
//  FXPingBiTableViewCell.h
//  FuXin
//
//  Created by SumFlower on 14-5-26.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//
@protocol FXPingBiTableViewCellDelegate <NSObject>

@required
-(void)didHuiFu;

@end
#import <UIKit/UIKit.h>

@interface FXPingBiTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIButton *huiFuBt;
@property (strong, nonatomic)id<FXPingBiTableViewCellDelegate>delegate;
-(void)initButton;
@end
