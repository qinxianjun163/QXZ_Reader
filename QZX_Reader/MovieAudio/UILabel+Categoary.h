//
//  UILabel+Categoary.h
//  QZX_Reader
//
//  Created by zhangsiyao on 15/9/26.
//  Copyright © 2015年 ZhangSiYao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Categoary)

- (void)detailWithStyle:(NSString *)style time:(NSInteger)time;

- (void)dateStrWithdate:(NSTimeInterval)date;

- (void)timeStrWithTime:(NSInteger)time;

@end
