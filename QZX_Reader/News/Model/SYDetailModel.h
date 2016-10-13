//
//  SYDetailModel.h
//  QZX_Reader
//
//  Created by zhangsiyao on 15/9/16.
//  Copyright (c) 2015年 ZhangSiYao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYDetailModel : NSObject

@property (copy, nonatomic) NSString *title;    //新闻标题
@property (copy, nonatomic) NSString *ptime;    //新闻发布时间
@property (copy, nonatomic) NSString *body; //新闻内容
@property (strong, nonatomic) NSArray *img;

+ (instancetype)detailWithDic:(NSDictionary *)dic;

@end
