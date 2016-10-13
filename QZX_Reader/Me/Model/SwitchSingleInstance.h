//
//  SwitchSingleInstance.h
//  QZX_Reader
//
//  Created by zhangsiyao on 15/9/24.
//  Copyright © 2015年 ZhangSiYao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SwitchSingleInstance : NSObject

@property (assign, nonatomic) BOOL isSwitch;

+ (instancetype)defaultSwitchSingleInstance;

@end
