//
//  SYPhotoSet.h
//  QZX_Reader
//
//  Created by zhangsiyao on 15/9/17.
//  Copyright (c) 2015年 ZhangSiYao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYPhotoSet : NSObject

// postID
@property (copy, nonatomic) NSString *postid;
// nil
@property (copy, nonatomic) NSString *series;
// 描述
@property (copy, nonatomic) NSString *desc;
// 发布日期
@property (copy, nonatomic) NSString *datatime;
// 创建日期
@property (copy, nonatomic) NSString *createdate;
@property (copy, nonatomic) NSString *relatedids;
// 蒙板背景图
@property (copy, nonatomic) NSString *scover;
// nil
@property (copy, nonatomic) NSString *autoid;
// 新闻原地址
@property (copy, nonatomic) NSString *url;
// 编辑
@property (copy, nonatomic) NSString *creator;

/** 里面装的是SXPhotosDetail对象*/
@property (strong, nonatomic) NSArray *photos;
@property (copy, nonatomic) NSString *reporter;
// 标题
@property (copy, nonatomic) NSString *setname;
// 封面
@property (copy, nonatomic) NSString *cover;
// 评论地址
@property (copy, nonatomic) NSString *commenturl;
// 来源
@property (copy, nonatomic) NSString *source;
// tag
@property (copy, nonatomic) NSString *settag;
// photoview_bbs 未知
@property (copy, nonatomic) NSString *boardid;
@property (copy, nonatomic) NSString *tcover;
// 图片数
@property (copy, nonatomic) NSNumber *imgsum;

@property (copy, nonatomic) NSString *clientadurl;

+ (instancetype)photoSetWith:(NSDictionary *)dic;

@end
