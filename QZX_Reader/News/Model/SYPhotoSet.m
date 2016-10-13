//
//  SYPhotoSet.m
//  QZX_Reader
//
//  Created by zhangsiyao on 15/9/17.
//  Copyright (c) 2015年 ZhangSiYao. All rights reserved.
//

#import "SYPhotoSet.h"
#import "SYPhotoDetail.h"

@implementation SYPhotoSet

+ (instancetype)photoSetWith:(NSDictionary *)dic {
    SYPhotoSet *photoSet = [SYPhotoSet new];
    [photoSet setValuesForKeysWithDictionary:dic];
    NSArray *photoArray = photoSet.photos;
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:photoArray.count];
    for (NSDictionary *dict in photoArray) {
        SYPhotoDetail *photoModel = [SYPhotoDetail photoDetailWithDic:dict];
        [tempArray addObject:photoModel];
    }
    photoSet.photos = tempArray;
    return photoSet;
}

@end
