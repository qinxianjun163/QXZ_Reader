//
//  SYHTTPManager.m
//  QZX_Reader
//
//  Created by zhangsiyao on 15/9/16.
//  Copyright (c) 2015年 ZhangSiYao. All rights reserved.
//

#import "SYHTTPManager.h"

@implementation SYHTTPManager

+ (instancetype)manager {
    SYHTTPManager *manager = [super manager];
    NSMutableSet *managerSet = [NSMutableSet set];
    managerSet.set = manager.responseSerializer.acceptableContentTypes;
    [managerSet addObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = managerSet;
    return manager;
}

@end
