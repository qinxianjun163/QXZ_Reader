//
//  HeightForHeaderSingleton.m
//  ReaderThreeTest
//
//  Created by 肖冯敏 on 15/9/15.
//  Copyright (c) 2015年 o‘clock. All rights reserved.
//

#import "HeightForHeaderSingleton.h"

@implementation HeightForHeaderSingleton

+ (HeightForHeaderSingleton *)shareInstance {
    static HeightForHeaderSingleton *s = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s = [[HeightForHeaderSingleton alloc] init];
    });
    return s;
}

@end
