//
//  FXEmojiView.m
//  FuXin
//
//  Created by 徐宝桥 on 14-5-22.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXEmojiView.h"

#define kRow    4
#define kNumber 7

#define kBtnSide  30
#define kSpace    15

@implementation FXEmojiView

@synthesize emojiDelegate = _emojiDelegate;
@synthesize emojiArray = _emojiArray;
@synthesize emojiScrollView = _emojiScrollView;
@synthesize pageControl = _pageControl;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

        _emojiArray = [Emoji allEmoji];
        [self initUI];
        [self loadEmoji];
    }
    return self;
}

- (void)initUI {
    self.backgroundColor = kColor(250, 250, 250, 1);
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
    topLine.backgroundColor = kColor(206, 206, 206, 1);
    [self addSubview:topLine];
    
    _emojiScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _emojiScrollView.pagingEnabled = YES;
    _emojiScrollView.delegate = self;
    _emojiScrollView.showsHorizontalScrollIndicator = NO;
    _emojiScrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:_emojiScrollView];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 190, 320, 20)];
    _pageControl.userInteractionEnabled = NO;
    [self addSubview:_pageControl];
}

- (void)loadEmoji {
    int page = [_emojiArray count] / (kRow * kNumber) + 1;
    _emojiScrollView.contentSize = CGSizeMake(page * self.bounds.size.width, self.bounds.size.height);
    for (int i = 0; i < [_emojiArray count]; i++) {
        //第几页
        CGFloat pageOffsetX = i / (kRow * kNumber) * self.bounds.size.width;
        //页内顺序
        int indexInPage = i % (kRow * kNumber);
        //行
        int row = indexInPage / kNumber;
        //列
        int number = indexInPage % kNumber;
        
        CGFloat offsetX = pageOffsetX + number * (kSpace + kBtnSide) + 10;
        CGFloat offsetY = row * (kSpace + kBtnSide) + 10;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(offsetX, offsetY, kBtnSide, kBtnSide);
        button.tag = i;
        [button setTitle:[_emojiArray objectAtIndex:i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(emojiSelected:) forControlEvents:UIControlEventTouchUpInside];
        [_emojiScrollView addSubview:button];
    }
    _pageControl.numberOfPages = page;
    _pageControl.currentPage = _emojiScrollView.contentOffset.x / self.frame.size.width;
}

- (IBAction)emojiSelected:(id)sender {
    NSLog(@"%d",[(UIButton *)sender tag]);
    if (_emojiDelegate && [_emojiDelegate respondsToSelector:@selector(touchEmojiButton:)]) {
        [_emojiDelegate touchEmojiButton:(UIButton *)sender];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _pageControl.currentPage = _emojiScrollView.contentOffset.x / self.frame.size.width;
}

@end
