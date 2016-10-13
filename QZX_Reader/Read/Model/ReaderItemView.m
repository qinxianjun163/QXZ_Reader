//
//  ReaderItemView.m
//  ReaderThreeTest
//
//  Created by 肖冯敏 on 15/9/24.
//  Copyright (c) 2015年 o‘clock. All rights reserved.
//

#import "ReaderItemView.h"

@implementation ReaderItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.itemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 2, 40, 40)];
        self.itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 42, 64, 20)];
        self.itemLabel.text = @"测试";
        self.itemLabel.font = [self.itemLabel.font fontWithSize:12];
        self.itemLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:self.itemImageView];
        [self addSubview:self.itemLabel];
    }
    return self;
}

@end
