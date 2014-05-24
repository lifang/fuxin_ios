//
//  FXTableHeaderView.h
//  FuXin
//
//  Created by 徐宝桥 on 14-5-22.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FXTableHeaderView : UITableViewHeaderFooterView

//索引图标
@property (nonatomic, strong) UILabel *indexLabel;
//人数
@property (nonatomic, strong) UILabel *numberLabel;

@property (nonatomic, assign, setter = setIsSelected:) BOOL isSelected;

@property (nonatomic, strong, setter = setNumberString:) NSString *numberString;

@end
