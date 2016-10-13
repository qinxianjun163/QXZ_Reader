//
//  UIColor+InvertColor.h
//  UIColor
//
//  Created by 肖冯敏 on 15/10/8.
//  Copyright © 2015年 o‘clock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (InvertColor)

- (UIColor*)brightnessColor:(UIColor *)color brightness:(float)brightness;//调高亮度 brightness 为调高的亮度数量 (0 ~ 1)
- (UIColor*)inverseColor:(UIColor *)color;//反色


@end
