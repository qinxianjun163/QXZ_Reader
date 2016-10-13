//
//  ReaderHeaderItemView.m
//  ReaderThreeTest
//
//  Created by 肖冯敏 on 15/9/24.
//  Copyright (c) 2015年 o‘clock. All rights reserved.
//

#import "ReaderHeaderItemView.h"
#import "LayoutMacro.h"

@implementation ReaderHeaderItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        CGPoint center = self.center;
        self.showAllItemView = [[ReaderItemView alloc] initWithFrame:CGRectMake(kScreenWidth / 4 - 32, 0, 64, 64)];
//        self.showAllItemView.center = CGPointMake(center.x - 64, center.y);
        self.showAllItemView.itemLabel.text = @"显示全部";
        self.showAllItemView.itemImageView.image = [UIImage imageNamed:@"iconfont-quanbu"];
        [self addSubview:self.showAllItemView];
        
        self.refreshItemView = [[ReaderItemView alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 32, 0, 64, 64)];
//        self.refreshItemView.center = CGPointMake(center.x, center.y);
        self.refreshItemView.itemLabel.text = @"刷新";
        self.refreshItemView.itemImageView.image = [UIImage imageNamed:@"iconfont-shuaxin"];
        [self addSubview:self.refreshItemView];
        
        self.subscriptionItemView = [[ReaderItemView alloc] initWithFrame:CGRectMake(kScreenWidth / 4 * 3 - 32 , 0, 64, 64)];
        self.subscriptionItemView.itemImageView.image = [UIImage imageNamed:@"iconfont-iconfontfinish"];
        self.subscriptionItemView.itemLabel.text = @"查看订阅";
        [self addSubview:self.subscriptionItemView];
        
    }
    return self;
}

@end
