//
//  Slider.m
//  Slider
//
//  Created by zhangsiyao on 15/9/26.
//  Copyright © 2015年 ZhangSiYao. All rights reserved.
//

#import "Slider.h"

@interface Slider ()

@property (nonatomic, strong) UIView *cacheView;    //缓存条View

@end

@implementation Slider
{
    CGFloat _thubmCenterX;  //记录thubmCenter的位置
}

- (void)dealloc {
    
    [self.thumb removeObserver:self forKeyPath:@"frame"];
    
    [self.thumb removeObserver:self forKeyPath:@"center"];
    
    [self.slider removeObserver:self forKeyPath:@"value"];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        //滑动视图
        self.slider = [[UISlider alloc] initWithFrame:self.bounds];
        
        [self.slider setThumbImage:[UIImage imageNamed:@"sliderView"] forState:UIControlStateNormal];  //隐藏滑块
        
        //KVO监视用户设置Slide的初始value
        [self.slider addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew context:nil];
        
        [self.slider addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventValueChanged];
        
        [self addSubview:self.slider];
        
        
        //缓存条视图
        self.cacheView = [[UIView alloc] initWithFrame:CGRectMake(0, (self.bounds.size.height - 2) / 2, 100, 2)];
        
        self.cacheView.backgroundColor = [UIColor whiteColor];
        
        self.cacheView.userInteractionEnabled = NO;
        
        [self addSubview:self.cacheView];
        
        
        //滑块
        self.thumb = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        
        UIImageView *sliderImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slider"]];
        
        sliderImage.frame = CGRectMake(0, 0, 20, 20);
        
        self.thumb = sliderImage;
        
        self.thumb.backgroundColor = [UIColor clearColor];
        
        self.thumb.userInteractionEnabled = NO;
        
        //添加一个KVO，如果外界改变了滑块的frame，做出响应的操作
        [self.thumb addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
        
        //KVO监视center的位置
        [self.thumb addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionNew context:nil];
        
        [self addSubview:self.thumb];
        
        
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
        [self addGestureRecognizer:tapGR];
    }
    return self;
}


#pragma mark - slider滑动过程中

- (void)changeValue:(UISlider *)slider {
    //修改thumb的位置
    
    //求出当前slider所在的百分比
    CGFloat progress = slider.value / (slider.maximumValue - slider.minimumValue);
    
    //求出滑块变化的位置
    CGFloat thumbX = progress * self.frame.size.width;
    
    self.thumb.center = CGPointMake(thumbX, self.frame.size.height / 2);
}


#pragma mark - 点击滑动

- (void)tapView:(UITapGestureRecognizer *)tap {
    
    
    CGPoint point = [tap locationInView:self];
    
    //做一个判断，如果点出去，则让滑块停在边缘
    if (point.x < 0) {
        
        point.x = 0;
    } else if (point.x > self.frame.size.width) {
        
        point.x = self.frame.size.width;
    }
    
    self.thumb.center = CGPointMake(point.x, self.frame.size.height / 2);
    
    CGFloat progress = point.x / self.frame.size.width;
    
    self.slider.value = progress;
    
    //将改变的value作为代理传出给调用者享用
    if ([_delegate respondsToSelector:@selector(touchView:)]) {
        
        [_delegate touchView:self.slider.value];
    }
}


#pragma mark - KVO检测滑块frame，center，value

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"frame"]) {
        
        self.thumb.center = CGPointMake(_thubmCenterX, self.frame.size.height / 2);
    }
    
    if ([keyPath isEqualToString:@"center"]) {
        
        _thubmCenterX = self.thumb.center.x;
    }
    
    if ([keyPath isEqualToString:@"value"]) {
        
        [self changeValue:self.slider];
    }
}


#pragma mark - 重写color的set方法，改变cache颜色

- (void)setCacheColor:(UIColor *)cacheColor {
    
    _cacheColor = cacheColor;
    
    self.cacheView.backgroundColor = cacheColor;
}


#pragma mark - 缓冲条数据

- (void)setCache:(CGFloat)cache {
    
    if (cache < self.slider.minimumValue) {
        
        cache = self.slider.minimumValue;
    }
    else if (cache > self.slider.maximumValue) {
        
        cache = self.slider.maximumValue;
    }
    
    _cache = cache;
    
    //计算出缓存条占整个缓存的比例
    CGFloat progress = cache / (self.slider.maximumValue - self.slider.minimumValue);
    
    CGFloat cacheWidth = progress * self.frame.size.width;
    
    self.cacheView.frame = CGRectMake(0, (self.frame.size.height - 2) / 2, cacheWidth, 2);
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    self.slider.frame = self.bounds;
}

@end
