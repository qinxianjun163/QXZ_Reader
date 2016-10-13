//
//  SYPhotoDetail.m
//  QZX_Reader
//
//  Created by zhangsiyao on 15/9/17.
//  Copyright (c) 2015年 ZhangSiYao. All rights reserved.
//

#import "SYPhotoDetail.h"

@implementation SYPhotoDetail

+ (instancetype)photoDetailWithDic:(NSDictionary *)dic {
    SYPhotoDetail *photoDetail = [SYPhotoDetail new];
    [photoDetail setValuesForKeysWithDictionary:dic];
    return photoDetail;
}

@end
