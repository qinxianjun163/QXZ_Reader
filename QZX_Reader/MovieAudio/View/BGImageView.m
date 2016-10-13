//
//  BGImageView.m
//  QZX_Reader
//
//  Created by zhangsiyao on 15/10/3.
//  Copyright © 2015年 ZhangSiYao. All rights reserved.
//

#import "BGImageView.h"
#import "UIImageView+WebCache.h"

@interface BGImageView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *movieImageView;

@end

@implementation BGImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        self.movieImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.delegate = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        _movieImageView.clipsToBounds = YES;
        self.maximumZoomScale  = 2.0;   //放大最大值
        self.minimumZoomScale = 0.5;    //缩小最小值
        [self zoomScale:nil];   //因为timer要等待8s时间，所以先手动调用一次
        self.timer = [NSTimer scheduledTimerWithTimeInterval:16 target:self selector:@selector(zoomScale:) userInfo:nil repeats:YES];
        [self addSubview:self.movieImageView];
    }
    return self;
}

- (void)setUrl:(NSString *)url {
    _url = url;
    [self.movieImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"CategoryPlaceholder"]];
}

- (void)zoomScale:(NSTimer *)timer {
    
    [UIView animateWithDuration:8 animations:^{
        self.zoomScale = 1.05;
    }];
    //延时4s执行shrink方法
    [self performSelector:@selector(shrink) withObject:timer afterDelay:8];
}

- (void)shrink {
    
    [UIView animateWithDuration:8 animations:^{
        self.zoomScale = 1.0;
    }];
}

#pragma mark - UIScrollViewDelegate代理方法

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _movieImageView;
}

@end
