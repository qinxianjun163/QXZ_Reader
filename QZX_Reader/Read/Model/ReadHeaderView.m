//
//  ReadHeaderView.m
//  ReaderThreeTest
//
//  Created by 肖冯敏 on 15/9/15.
//  Copyright (c) 2015年 o‘clock. All rights reserved.
//

#import "ReadHeaderView.h"
#import "HeightForHeaderSingleton.h"
#import "LayoutMacro.h"
#import "UIImage+WebP.h"
#import "UIView+Frame.h"
#import "HeaderHeight.h"
#import "ThemeColor.h"
#import "UIColor+InvertColor.h"
#import "ChangeBackGroundColor.h"

@implementation ReadHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        
        UIVisualEffectView *visualEfView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        visualEfView.frame = CGRectMake(0, 0, self.width, self.height);
        [self addSubview:visualEfView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 54 + 75, kScreenWidth, 27)];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = [UIColor whiteColor];
        [self bringSubviewToFront:self.titleLabel];
        [self addSubview:self.titleLabel];
        
        self.describeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.titleLabel.y + self.titleLabel.height + 10, kScreenWidth, 30)];
        self.describeLabel.font = [UIFont systemFontOfSize:18];
        self.describeLabel.textColor = [UIColor darkGrayColor];
        self.describeLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.describeLabel];
        
        UIImageView *backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Back_Gray"]];
        backImageView.frame = CGRectMake(10, 30, 20, 20);
        [self addSubview:backImageView];
        self.backButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.backButton.frame = CGRectMake(10, 30, 70, 20);
        [self.backButton setTitle:@"返回" forState:UIControlStateNormal];
        self.backButton.tintColor = [UIColor grayColor];
        [self addSubview:self.backButton];
        
        self.subscriptionButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.subscriptionButton.frame = CGRectMake(kScreenWidth - 70, 30, 50, 20);
        self.subscriptionButton.tintColor = [UIColor grayColor];
        [self.subscriptionButton setTitle:@"订阅" forState:UIControlStateNormal];
        [self.subscriptionButton setTitle:@"已订阅" forState:UIControlStateSelected];
        [self.subscriptionButton addTarget:self.delegate action:@selector(subscription:) forControlEvents:UIControlEventTouchUpInside];
        [self bringSubviewToFront:self.subscriptionButton];
        [self addSubview:self.subscriptionButton];
    }
    return self;
}

- (UIColor *)createImageView {
    NSString *cache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [cache stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.webp", self.tname]];
    self.backgroundImageView = [UIImageView new];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        self.backgroundImageView.image = [UIImage imageWithWebP:filePath];
    } else {
        self.backgroundImageView.image = [UIImage imageWithWebPData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://s.cimg.163.com/pi/img3.cache.netease.com/m/newsapp/topic_icons/%@.png.100x100.75.auto.webp", self.tid]]]];
    }
    self.backgroundColor = [UIColor colorWithPatternImage:self.backgroundImageView.image];
    self.backgroundImageView.frame = CGRectMake(0, 0, 75, 75);
    self.backgroundImageView.center = self.center;
    self.backgroundImageView.y = 35;
    self.backgroundImageView.layer.cornerRadius = self.backgroundImageView.width / 8;
    [self addSubview:self.backgroundImageView];
    UIColor *mostColor = [ChangeBackGroundColor mostColor:self.backgroundImageView.image];
    UIColor *returnColor = [mostColor brightnessColor:mostColor brightness:1.0];
    return returnColor;
}

- (void)updateHeaderView {
    CGFloat height = self.height;
    CGFloat titleY = (220 * 20.0 / 64.0 / 129.0);
    
    self.titleLabel.frame = CGRectMake(0, height * titleY, kScreenWidth, MAX(27, height / 4));
    self.describeLabel.frame = CGRectMake(0, self.titleLabel.y + 40 + 12, kScreenWidth, self.describeLabel.height);
    if (height == 64) {
        self.titleLabel.y -= 5;
    }
    self.describeLabel.alpha = MAX((height - 110) / 110, 0);
    self.backgroundImageView.frame = CGRectMake(self.backgroundImageView.x, height - kHeaderHeight + 35, self.backgroundImageView.width, self.backgroundImageView.height);
    self.backgroundImageView.alpha = (height - kScreenHeight / 12) / kScreenHeight * 4;
    [self reloadInputViews];
}

@end
