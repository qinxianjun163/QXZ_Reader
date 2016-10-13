//
//  SYDetailModel.m
//  QZX_Reader
//
//  Created by zhangsiyao on 15/9/16.
//  Copyright (c) 2015年 ZhangSiYao. All rights reserved.
//

#import "SYDetailModel.h"
#import "SYDetailImageModel.h"

@implementation SYDetailModel

+ (instancetype)detailWithDic:(NSDictionary *)dic {
    SYDetailModel *detailModel = [self new];
    detailModel.title = dic[@"title"];
    detailModel.ptime = dic[@"ptime"];
    detailModel.body = dic[@"body"];
    NSArray *imageArray = dic[@"img"];
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:imageArray.count];
    for (NSDictionary *dic in imageArray) {
        SYDetailImageModel *imageModel = [SYDetailImageModel detailImageWithDic:dic];
        [tempArray addObject:imageModel];
    }
    detailModel.img = tempArray;
    return detailModel;
}

@end
