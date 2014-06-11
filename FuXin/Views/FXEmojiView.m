//
//  FXEmojiView.m
//  FuXin
//
//  Created by 徐宝桥 on 14-5-22.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXEmojiView.h"

#define kRow    3
#define kNumber 7

#define kFirstSpace  25
#define kBtnSide     30
#define kHSpace      10      //水平间距
#define kVSpace      15      //垂直间距

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

//        _emojiArray = [Emoji allEmoji];
        [self addImage];
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
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 180, 320, 20)];
    _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    _pageControl.userInteractionEnabled = NO;
    [self addSubview:_pageControl];
}

- (void)addImage {
    _emojiArray = [[NSMutableArray alloc] init];
    for (int i = 1; i <= 40; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png",i]];
        [_emojiArray addObject:image];
    }
    UIImage *delete = [UIImage imageNamed:@"delete.png"];
    [_emojiArray insertObject:delete atIndex:20];
}

- (void)loadEmoji {
    int page = [_emojiArray count] / (kRow * kNumber) + 1;
    _emojiScrollView.contentSize = CGSizeMake(page * self.bounds.size.width, self.bounds.size.height);
    for (int i = 0; i <= [_emojiArray count]; i++) {
        //第几页
        CGFloat pageOffsetX = i / (kRow * kNumber) * self.bounds.size.width;
        //页内顺序
        int indexInPage = i % (kRow * kNumber);
        //行
        int row = indexInPage / kNumber;
        //列
        int number = indexInPage % kNumber;
        
        CGFloat offsetX = pageOffsetX + number * (kHSpace + kBtnSide) + kFirstSpace;
        CGFloat offsetY = row * (kVSpace + kBtnSide) + kFirstSpace;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(offsetX, offsetY, kBtnSide, kBtnSide);
        button.tag = i;
        if (i == [_emojiArray count]) {
            [button setImage:[_emojiArray objectAtIndex:20] forState:UIControlStateNormal];
        }
        else {
            [button setImage:[_emojiArray objectAtIndex:i] forState:UIControlStateNormal];
        }
        [button addTarget:self action:@selector(emojiSelected:) forControlEvents:UIControlEventTouchUpInside];
        [_emojiScrollView addSubview:button];
    }
    _pageControl.numberOfPages = page;
    _pageControl.currentPage = _emojiScrollView.contentOffset.x / self.frame.size.width;
    
    for (int i = 0; i < page; i++) {
        UIButton *send = [UIButton buttonWithType:UIButtonTypeCustom];
        send.frame = CGRectMake(240 + i * 320, 160, 60, 30);
        [send setBackgroundColor:kColor(0, 121, 255, 1)];
        send.titleLabel.font = [UIFont systemFontOfSize:14];
        [send setTitle:@"发送" forState:UIControlStateNormal];
        [send setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [send setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [send addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
        [_emojiScrollView addSubview:send];
    }
}

- (IBAction)emojiSelected:(id)sender {
    if (_emojiDelegate && [_emojiDelegate respondsToSelector:@selector(touchEmojiButton:)]) {
        [_emojiDelegate touchEmojiButton:(UIButton *)sender];
    }
}

- (IBAction)sendMessage:(UIButton *)sender {
    [sender setBackgroundColor:kColor(0, 121, 255, 1)];
    if (_emojiDelegate && [_emojiDelegate respondsToSelector:@selector(sendMessage)]) {
        [_emojiDelegate sendMessage];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _pageControl.currentPage = _emojiScrollView.contentOffset.x / self.frame.size.width;
}

@end
