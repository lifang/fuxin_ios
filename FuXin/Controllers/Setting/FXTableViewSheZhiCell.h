//
//  FXTableViewSheZhiCell.h
//  FuXin
//
//  Created by SumFlower on 14-5-25.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface FXTableViewSheZhiCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *setImage;
@property (weak, nonatomic) IBOutlet UILabel *setName;
@property (weak, nonatomic) IBOutlet UILabel *count;
-(void)setlabel;
@end
