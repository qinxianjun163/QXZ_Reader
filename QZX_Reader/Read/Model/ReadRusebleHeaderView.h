//
//  ReadRusebleHeaderView.h
//  ReaderThreeTest
//
//  Created by 肖冯敏 on 15/9/18.
//  Copyright (c) 2015年 o‘clock. All rights reserved.
//

#import "ReadRusableView.h"

//显示 第一个界面的header

@protocol ReadRusebleHeaderViewDelegate<NSObject>

//点击按钮触发的方法
- (void)turnToSelectedIndexPath:(UIButton *)button; //点击中间按钮触发的事件, 跳转到指定的页面

- (void)turnToAllSectionSelectedViewController;   //跳转到滑动选择 页面

@end

@interface ReadRusebleHeaderView : ReadRusableView

@property (nonatomic, strong) UILabel *titleView; //给buttonSection 存放
@property (nonatomic, strong) UIView *sectionView; //给buttonAll 存放
@property (nonatomic, strong) UIButton *buttonSection;

@property (nonatomic, assign) id<ReadRusebleHeaderViewDelegate> delegate; //代理方法, 让他的代理执行 跳转方法

@end
