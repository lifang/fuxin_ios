//
//  FXShowPhotoView.h
//  FuXin
//
//  Created by 徐宝桥 on 14-5-25.
//  Copyright (c) 2014年 ___MyCompanyName___. All rights reserved.
//

typedef enum {
    ButtonTagNone = 0,
    ButtonTagePicture,
    ButtonTagPhoto,
}ButtonTags;

#import <UIKit/UIKit.h>

@protocol PictureButtonDelegate;

@interface FXShowPhotoView : UIScrollView

@property (nonatomic, assign) id<PictureButtonDelegate> pictureDelegate;

@end

@protocol PictureButtonDelegate <NSObject>

- (void)pictureButtonFunctionWithTag:(ButtonTags)tag;

@end