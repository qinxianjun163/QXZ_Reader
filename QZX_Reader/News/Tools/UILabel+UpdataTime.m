//
//  UILabel+UpdataTime.m
//  QZX_Reader
//
//  Created by zhangsiyao on 15/10/8.
//  Copyright © 2015年 ZhangSiYao. All rights reserved.
//

#import "UILabel+UpdataTime.h"

@implementation UILabel (UpdataTime)

- (void)changeUpdataTimeFromDate:(NSString *)date {
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    NSDate *ptime = [formatter dateFromString:date];
    double mul = [[NSDate dateWithTimeIntervalSinceNow:60 * 60 * 8] timeIntervalSinceDate:ptime] / 60.0;
    if (mul < 60) {
        if (mul < 5) {
            self.text = @"- 刚刚更新 -";
        } else {
            self.text = [NSString stringWithFormat:@"- %d分钟前 -", (int)mul];
        }
    } else if (mul < 60 * 24) {
        self.text = [NSString stringWithFormat:@"- %d小时前 -", (int)mul / 60];
    } else {
        self.text = [NSString stringWithFormat:@"- %d天前 -", (int)mul / 60 / 24];
    }
}

@end
