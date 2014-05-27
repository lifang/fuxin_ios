//
//  FXSettingTableViewCell.h
//  FuXin
//
//  Created by SumFlower on 14-5-24.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FXSettingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *userSex;
@property (weak, nonatomic) IBOutlet UIButton *userTitleOne;
@property (weak, nonatomic) IBOutlet UIButton *userTitleTwo;
@property (weak, nonatomic) IBOutlet UIButton *userTitleThree;
-(void)initCellImage;
@end
