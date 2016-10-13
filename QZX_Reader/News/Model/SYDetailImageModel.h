//
//  SYDetailImageModel.h
//  QZX_Reader
//
//  Created by zhangsiyao on 15/9/16.
//  Copyright (c) 2015年 ZhangSiYao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYDetailImageModel : NSObject

@property (copy, nonatomic) NSString *src;
@property (copy, nonatomic) NSString *pixel;    //图片尺寸
@property (copy, nonatomic) NSString *ref;  //图片所在位置

+ (instancetype)detailImageWithDic:(NSDictionary *)dic;

@end
