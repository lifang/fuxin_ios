//
//  FXContactCell.h
//  FuXin
//
//  Created by 徐宝桥 on 14-6-17.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FXContactCell : UITableViewCell

@property (nonatomic, strong) UIImageView *photoView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *remarkLabel;

@property (nonatomic, strong) UIImageView *sexView;

@property (nonatomic, strong) UIImageView *relationView1;
@property (nonatomic, strong) UIImageView *relationView2;

- (void)showOrder:(BOOL)showFirst showSubscribe:(BOOL)showSecond;

@end
