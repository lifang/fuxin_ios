//
//  FXMessageBoxCell.h
//  FuXin
//
//  Created by 徐宝桥 on 14-5-21.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXTextFormat.h"

#define kTimeLabelHeight    40

typedef enum {
    MessageCellStyleNone = 0,
    MessageCellStyleSender,    //发送样式
    MessageCellStyleReceive,   //接收样式
}MessageCellStyles;   //cell样式

@interface FXMessageBoxCell : UITableViewCell

//消息样式发送还是接收
@property (nonatomic, assign) MessageCellStyles cellStyle;

//用户头像
@property (nonatomic, strong) UIImageView *userPhotoView;

//聊天背景框
@property (nonatomic, strong) UIImageView *backgroundView;

//内容框
//@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *messageView;

//时间框
@property (nonatomic, strong) UILabel *timeLabel;

//是否显示时间框
@property (nonatomic, assign, setter = setShowTime:) BOOL showTime;

//包含图片编码的字符串
@property (nonatomic, strong, setter = setContents:) NSString *contents;

@end
