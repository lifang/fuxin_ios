//
//  FXSelectIndexView.h
//  FuXin
//
//  Created by 徐宝桥 on 14-5-24.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

//通讯录右侧索引栏悬浮框

#import <UIKit/UIKit.h>

@interface FXSelectIndexView : UIView

@property (nonatomic, strong) UIImageView *indexView;

@property (nonatomic, strong) UILabel *indexLabel;

@property (nonatomic, assign) NSInteger currentIndex;

- (void)moveToIndex:(NSInteger)toIndex
       withAllIndex:(NSInteger)allIndex
         withHeight:(CGFloat)height;

@end
