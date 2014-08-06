//
//  FXSettingUserCell.h
//  FuXin
//
//  Created by 徐宝桥 on 14-6-2.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    UserBtnNone = 0,
    UserBtnInfo,
    UserBtnMessage,
    UserBtnPhone,
}UserBtnTags;

@interface FXSettingUserCell : UITableViewCell

@property (nonatomic, strong) UIImageView *photoView;
@property (nonatomic, strong) UILabel *nameLabel;
//@property (nonatomic, strong) UIImageView *sexView;
//@property (nonatomic, strong) UIButton *infoButton;
//@property (nonatomic, strong) UIButton *msgButton;
//@property (nonatomic, strong) UIButton *phoneButton;

@property (nonatomic, strong) UILabel *remarkLabel;

//- (void)showRealName:(BOOL)showReal showMessage:(BOOL)showMsg showPhone:(BOOL)showPhone;

@end
