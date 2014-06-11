//
//  FXAddressListCell.h
//  FuXin
//
//  Created by 徐宝桥 on 14-5-25.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXListCell.h"

@interface FXAddressListCell : FXListCell

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UIImageView *relationView1;
@property (nonatomic, strong) UIImageView *relationView2;

- (void)showOrder:(BOOL)showFirst showSubscribe:(BOOL)showSecond;

@end
