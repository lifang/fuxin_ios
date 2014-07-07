//
//  FXMessageBoxCell.h
//  FuXin
//
//  Created by 徐宝桥 on 14-5-21.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXTextFormat.h"

@class FXMessageBoxCell;

@protocol TouchContactDelegate <NSObject>

- (void)touchContact:(UIGestureRecognizer *)tap;

//查看联系人发送的大图
- (void)loadLargeImageWithURL:(NSString *)urlString;

//查看自己发送的大图
- (void)loadLargeImageWithData:(NSData *)data;

- (void)reSendMessageForCell:(FXMessageBoxCell *)cell;

@end

#define kTimeLabelHeight    40

typedef enum {
    MessageCellStyleNone = 0,
    MessageCellStyleSender,    //发送样式
    MessageCellStyleReceive,   //接收样式
}MessageCellStyles;   //cell样式

@interface FXMessageBoxCell : UITableViewCell

@property (nonatomic, assign) id<TouchContactDelegate>delegate;

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

//时间背景框
@property (nonatomic, strong) UIImageView *timeBackView;

//图片地址
@property (nonatomic, strong) NSString *imageURL;

//用于保存自己发送的图片
@property (nonatomic, strong) NSData *imageData;
//发送状态
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
//重发按钮
@property (nonatomic, strong) UIButton *reSendBtn;

- (void)setImageData:(NSData *)data;

- (void)setNullView;

- (void)showSendingStatus;

- (void)showWarningStatus;

@end
