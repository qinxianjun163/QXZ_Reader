//
//  ShowView.m
//  ReaderThreeTest
//
//  Created by 肖冯敏 on 15/9/14.
//  Copyright (c) 2015年 o‘clock. All rights reserved.
//

#import "ShowView.h"
#import "LayoutMacro.h"
#import "UIView+Frame.h"

@implementation ShowView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIVisualEffectView *visualEfView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        visualEfView.frame = CGRectMake(0, 0, self.width, self.height);
        [self addSubview:visualEfView];
        
        self.imageSrcView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - 100) / 2, 35, 100, 100)];
        [self addSubview:self.imageSrcView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.imageSrcView.y + self.imageSrcView.height + 30, kScreenWidth, 50)];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:30];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.userInteractionEnabled = YES;
        [self addSubview:self.titleLabel];
        
        self.describeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.titleLabel.y + self.titleLabel.height + 10, kScreenWidth, 30)];
        self.describeLabel.font = [UIFont systemFontOfSize:20];
        self.describeLabel.textColor = [UIColor grayColor];
        self.describeLabel.textAlignment = NSTextAlignmentCenter;
        self.describeLabel.userInteractionEnabled = YES;
        [self addSubview:self.describeLabel];
        
        self.subnumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.describeLabel.y + self.describeLabel.height + 10, kScreenWidth, 20)];
        self.subnumLabel.textColor = [UIColor lightGrayColor];
        self.subnumLabel.textAlignment = NSTextAlignmentCenter;
        self.subnumLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.subnumLabel];
    }
    return self;
}

@end
