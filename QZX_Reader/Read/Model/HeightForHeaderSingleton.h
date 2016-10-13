//
//  HeightForHeaderSingleton.h
//  ReaderThreeTest
//
//  Created by 肖冯敏 on 15/9/15.
//  Copyright (c) 2015年 o‘clock. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HeightForHeaderSingleton : NSObject

@property (nonatomic, assign) float height;

+ (HeightForHeaderSingleton *)shareInstance;

@end
