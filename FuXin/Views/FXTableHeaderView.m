//
//  FXTableHeaderView.m
//  FuXin
//
//  Created by 徐宝桥 on 14-5-22.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXTableHeaderView.h"

@implementation FXTableHeaderView

@synthesize indexLabel = _indexLabel;
@synthesize numberLabel = _numberLabel;
@synthesize isSelected = _isSelected;
@synthesize numberString = _numberString;

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
//    self.backgroundColor = kColor(244, 244, 244, 1);
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
    topView.backgroundColor = [UIColor grayColor];
    topView.alpha = 0.2;
    [self addSubview:topView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1)];
    bottomView.backgroundColor = [UIColor grayColor];
    bottomView.alpha = 0.2;
    [self addSubview:bottomView];
    
    _indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 40, self.frame.size.height)];
    _indexLabel.backgroundColor = [UIColor clearColor];
    _indexLabel.font = [UIFont boldSystemFontOfSize:14
                        ];
    _indexLabel.textColor = [UIColor blackColor];
    _indexLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_indexLabel];
    
    _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 100, self.frame.size.height)];
    _numberLabel.backgroundColor = [UIColor clearColor];
    _numberLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:_numberLabel];
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    if (_isSelected) {
        _indexLabel.textColor = [UIColor redColor];
    }
    else {
        _indexLabel.textColor = [UIColor grayColor];
    }
}

- (void)setNumberString:(NSString *)numberString {
    _numberLabel.text = [NSString stringWithFormat:@"[%@人]",numberString];
}

@end
