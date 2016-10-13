//
//  SYPhotoDetail.h
//  QZX_Reader
//
//  Created by zhangsiyao on 15/9/17.
//  Copyright (c) 2015年 ZhangSiYao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface SYPhotoDetail : NSObject

// 图片URL
@property (copy, nonatomic) NSString *timgurl;
// 图片对应的URL网址
@property (copy, nonatomic) NSString *photohtml;
// 默认新建网页首页 ＃
@property (copy, nonatomic) NSString *newsurl;
// 方形图片URL
@property (copy, nonatomic) NSString *squareimgurl;
// cimg图片URL
@property (copy, nonatomic) NSString *cimgurl;
// 图片标题
@property (copy, nonatomic) NSString *imgtitle;
@property (copy, nonatomic) NSString *simgurl;
// 标签
@property (copy, nonatomic) NSString *note;
// 图片ID
@property (copy, nonatomic) NSString *photoid;
// 图片下载地址
@property (copy, nonatomic) NSString *imgurl;

+ (instancetype)photoDetailWithDic:(NSDictionary *)dic;

@end
