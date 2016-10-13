//
//  UIColor+InvertColor.m
//  UIColor
//
//  Created by 肖冯敏 on 15/10/8.
//  Copyright © 2015年 o‘clock. All rights reserved.
//

#import "UIColor+InvertColor.h"

@implementation UIColor (InvertColor)

- (UIColor*)inverseColor:(UIColor *)color
{
    CGFloat r,g,b,a;
    [color getRed:&r green:&g blue:&b alpha:&a];
    return [UIColor colorWithRed:1.-r green:1.-g blue:1.-b alpha:a];
}

- (UIColor*)brightnessColor:(UIColor *)color brightness:(float)brightness
{
    CGFloat r,g,b,a;
    [color getHue:&r saturation:&g brightness:&b alpha:&a];
    return [UIColor colorWithHue:r saturation:g brightness:b + brightness alpha:a];
}

@end
