//
//  FXInfoView.m
//  FuXin
//
//  Created by 徐宝桥 on 14-6-17.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import "FXInfoView.h"

@implementation FXInfoView

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
    _activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(5, 10, 20, 20)];
    _activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    _activityView.hidesWhenStopped = YES;
    [_activityView startAnimating];
    [self addSubview:_activityView];
    
    _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 10, 95, 20)];
    _infoLabel.backgroundColor = [UIColor clearColor];
    _infoLabel.textAlignment = NSTextAlignmentCenter;
    _infoLabel.textColor = [UIColor whiteColor];
    _infoLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:_infoLabel];
}

- (void)setText:(NSString *)text {
    _infoLabel.text = text;
}

- (void)show {
    self.alpha = 1;
    self.hidden = NO;
    _infoLabel.frame = CGRectMake(25, 10, 95, 20);
    [_activityView startAnimating];
}

- (void)hide {
    [_activityView stopAnimating];
    _infoLabel.frame = CGRectMake(5, 10, 110, 20);
    [UIView animateWithDuration:1.4 animations:^{
        self.alpha = 0;
    }completion:^(BOOL finish) {
        self.hidden = YES;
    }];
}

@end
