//
//  SYDetailImageModel.m
//  QZX_Reader
//
//  Created by zhangsiyao on 15/9/16.
//  Copyright (c) 2015年 ZhangSiYao. All rights reserved.
//

#import "SYDetailImageModel.h"

@implementation SYDetailImageModel

+ (instancetype)detailImageWithDic:(NSDictionary *)dic {
    SYDetailImageModel *imageModel = [self new];
    imageModel.ref = dic[@"ref"];
    imageModel.pixel = dic[@"pixel"];
    imageModel.src = dic[@"src"];
    return imageModel;
}

@end
