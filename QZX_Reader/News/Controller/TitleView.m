//
//  TitleView.m
//  QZX_Reader
//
//  Created by zhangsiyao on 15/9/14.
//  Copyright (c) 2015年 ZhangSiYao. All rights reserved.
//

#import "TitleView.h"
#import "UIView+Frame.h"

@implementation TitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.image = [[UIImageView alloc] initWithFrame:CGRectMake((self.width - 30) / 2, 5, 30, 30)];
        [self addSubview:self.image];
        self.scale = 0.0;
    }
    return self;
}

- (void)setScale:(CGFloat)scale {
    _scale = scale;
    CGFloat minScale = 0.7;
    CGFloat trueScale = minScale + (1 - minScale) * scale;
    self.transform = CGAffineTransformMakeScale(trueScale, trueScale);
    self.alpha = trueScale;
}

@end
