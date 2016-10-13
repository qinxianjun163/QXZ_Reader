//
//  SYNewsModel.m
//  QZX_Reader
//
//  Created by zhangsiyao on 15/9/15.
//  Copyright (c) 2015年 ZhangSiYao. All rights reserved.
//

#import "SYNewsModel.h"

@implementation SYNewsModel

+ (instancetype)newsModelWithDict:(NSDictionary *)dict
{
    SYNewsModel * model = [[self alloc] init];
    
    [model setValuesForKeysWithDictionary:dict];
    
    return model;
}

@end
