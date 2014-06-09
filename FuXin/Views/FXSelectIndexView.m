//
//  FXSelectIndexView.m
//  FuXin
//
//  Created by 徐宝桥 on 14-5-24.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXSelectIndexView.h"

static CGFloat iOS7_Space = 14;

@implementation FXSelectIndexView

@synthesize indexView = _indexView;
@synthesize indexLabel = _indexLabel;
@synthesize currentIndex = _currentIndex;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _indexView = [[UIImageView alloc] initWithFrame:self.bounds];
    _indexView.image = [UIImage imageNamed:@"index.png"];
    [self addSubview:_indexView];
    
    _indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 9, self.frame.size.width - 3, 20)];
    _indexLabel.backgroundColor = [UIColor clearColor];
    _indexLabel.font = [UIFont boldSystemFontOfSize:14];
    _indexLabel.textAlignment = NSTextAlignmentCenter;
    _indexLabel.textColor = [UIColor whiteColor];
    [self addSubview:_indexLabel];
    
    _currentIndex = -1;
    if (kDeviceVersion < 7.0) {
        CGRect rect = self.frame;
        rect.origin.x -= 10;
        self.frame = rect;
    }
}

- (void)moveToIndex:(NSInteger)toIndex withAllIndex:(NSInteger)allIndex withHeight:(CGFloat)height {
    if (self.hidden) {
        self.hidden = NO;
    }
    float index = _currentIndex;
    if (_currentIndex < 0) {
        index = (float)(allIndex + 1) / 2;
    }
    CGFloat space = [self getSpaceWithHeight:height allIndex:allIndex];
    CGFloat offset = -(index - (toIndex + 1)) * space;
    NSLog(@"%ld,%ld,%ld,%g",(long)_currentIndex,(long)allIndex,toIndex,offset);
    [self indexViewAnimaitonWithOffset:offset];
    _currentIndex = toIndex + 1;
}

- (CGFloat)getSpaceWithHeight:(CGFloat)height allIndex:(NSInteger)allIndex {
    if (kDeviceVersion >= 7.0) {
        return iOS7_Space;
    }
    else {
        return (height / (allIndex - 1)) - 9;
    }
}

- (void)indexViewAnimaitonWithOffset:(CGFloat)offset {
    CGRect rect = self.frame;
    rect.origin.y += offset;
    [UIView beginAnimations:@"Move" context:nil];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    self.frame = rect;
    [UIView commitAnimations];
}

@end
