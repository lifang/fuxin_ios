//
//  FXListCell.h
//  FuXin
//
//  Created by 徐宝桥 on 14-6-10.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FXListCell : UITableViewCell

@property (nonatomic, strong) UIImageView *photoView;

//用于判断异步加载图片
@property (nonatomic, strong) NSString *imageURL;

@end
