//
//  MoviePlayer.h
//  QZX_Reader
//
//  Created by zhangsiyao on 15/10/3.
//  Copyright © 2015年 ZhangSiYao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Slider.h"

typedef NS_ENUM(NSInteger, PanDirection) {
    PanDirectionHorizontalMoved,
    PanDirectionVerticalMoved
};

@protocol MoviePlayerDelegate <NSObject>

- (void)back;   //点击返回按钮执行的方法

@end

@interface MoviePlayer : UIView

@property (strong, nonatomic) NSString *title;//视频名称
@property (assign, nonatomic) id <MoviePlayerDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame URL:(NSURL *)url;

@end
