//
//  FXEmojiView.h
//  FuXin
//
//  Created by 徐宝桥 on 14-5-22.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Emoji.h"

@protocol EmojiDelegate;

@interface FXEmojiView : UIView<UIScrollViewDelegate>

@property (nonatomic, assign) id<EmojiDelegate> emojiDelegate;

@property (nonatomic, strong) NSMutableArray *emojiArray;

@property (nonatomic, strong) UIScrollView *emojiScrollView;

@property (nonatomic, strong) UIPageControl *pageControl;

@end

@protocol EmojiDelegate <NSObject>

- (void)touchEmojiButton:(UIButton *)sender;

- (void)sendMessage;

@end
