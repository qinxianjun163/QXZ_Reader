//
//  ReadRusebleHeaderView.m
//  ReaderThreeTest
//
//  Created by 肖冯敏 on 15/9/18.
//  Copyright (c) 2015年 o‘clock. All rights reserved.
//

#import "ReadRusebleHeaderView.h"
#import "ThemeColor.h"
#import "UIView+Frame.h"
#import "LayoutMacro.h"

@interface ReadRusebleHeaderView()

@end

@implementation ReadRusebleHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *roundView = [[UIView alloc] initWithFrame:CGRectMake(20, 10, kScreenWidth / 4 - 20, kScreenWidth / 4 - 20)];
        roundView.backgroundColor = kThemeColor;
        roundView.layer.cornerRadius = roundView.width / 2.0;
        
        self.titleView = [[UILabel alloc] initWithFrame:roundView.bounds];
        self.titleView.center = roundView.center;
        self.titleView.backgroundColor = [UIColor clearColor];
        self.titleView.textAlignment = NSTextAlignmentCenter;
        
        self.sectionView = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width / 3, 0, frame.size.width / 3 * 2, frame.size.height)];
        self.sectionView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.sectionView];
        
        self.buttonSection = [UIButton buttonWithType:UIButtonTypeSystem];
        self.buttonSection.tintColor = kThemeColor;
        self.buttonSection.titleLabel.font = [UIFont systemFontOfSize:20];
        self.buttonSection.frame = CGRectMake(0 , 0, frame.size.width / 3 * 2, frame.size.height);
        [self.buttonSection addTarget:self.delegate action:@selector(turnToSelectedIndexPath:) forControlEvents:UIControlEventTouchUpInside];
        self.buttonSection.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        self.buttonSection.contentEdgeInsets = UIEdgeInsetsMake(0,0, 0, 40);
        [self.sectionView addSubview:self.buttonSection];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Arrowhead_Right"]];
        imageView.frame = CGRectMake(kScreenWidth - 40, (self.height - 30) / 2, 30, 30);
        
        [self addSubview:roundView];
        [self addSubview:self.titleView];
        [self addSubview:imageView];
    }
    return self;
}

@end
