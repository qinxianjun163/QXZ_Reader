//
//  DIYButton.h
//  QZX_Reader
//
//  Created by zhangsiyao on 15/10/3.
//  Copyright © 2015年 ZhangSiYao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DIYButton : UIButton

@property (strong, nonatomic, readonly) UIImageView *icon;//button的图片显示
@property (strong, nonatomic, readonly) UIImageView *iconSelected;//button selected状态下的图片
@property (strong, nonatomic, readonly) UILabel *textLabel;//文字显示

@end
