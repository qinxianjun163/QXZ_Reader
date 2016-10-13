//
//  SwitchSingleInstance.m
//  QZX_Reader
//
//  Created by zhangsiyao on 15/9/24.
//  Copyright © 2015年 ZhangSiYao. All rights reserved.
//

#import "SwitchSingleInstance.h"

@implementation SwitchSingleInstance

//单例方法
+ (SwitchSingleInstance *)defaultSwitchSingleInstance {
    
    static SwitchSingleInstance *mySwitch = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mySwitch = [[SwitchSingleInstance alloc] init];
    });
    return mySwitch;
}

@end
