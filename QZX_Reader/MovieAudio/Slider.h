//
//  Slider.h
//  Slider
//
//  Created by zhangsiyao on 15/9/26.
//  Copyright © 2015年 ZhangSiYao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SliderDelegate <NSObject>

- (void)touchView:(CGFloat)value;

@end

@interface Slider : UIView

@property (nonatomic, strong) UIView *thumb;

@property (nonatomic, strong) UISlider *slider;

@property (nonatomic, assign) CGFloat cache;    //获取缓存进度

@property (nonatomic, strong) UIColor *cacheColor;  //缓冲条颜色

@property (nonatomic, assign) id <SliderDelegate> delegate;

@end
