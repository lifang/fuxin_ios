//
//  FXHistoryCell.h
//  FuXin
//
//  Created by 徐宝桥 on 14-9-22.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXTextFormat.h"
#import "FXTimeFormat.h"

@interface FXHistoryCell : UITableViewCell

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIView *messageView;

//包含图片编码的字符串
@property (nonatomic, strong, setter = setContents:) NSString *contents;

@property (nonatomic, strong) NSData *imageData;

@property (nonatomic, strong) NSString *imageURL;

- (void)setSubviewsFrame;
- (void)setNullView;
- (void)setImageData:(NSData *)data;

- (void)setName:(NSString *)name userID:(int32_t)userID;
- (void)setTime:(NSString *)time;

@end
