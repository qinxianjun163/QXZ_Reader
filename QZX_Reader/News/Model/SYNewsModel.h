//
//  SYNewsModel.h
//  QZX_Reader
//
//  Created by zhangsiyao on 15/9/15.
//  Copyright (c) 2015年 ZhangSiYao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYNewsModel : NSObject

@property (copy, nonatomic) NSString *tname;
/**
 *  新闻发布时间
 */
@property (copy, nonatomic) NSString *ptime;
/**
 *  标题
 */
@property (copy, nonatomic) NSString *title;
/**
 *  多图数组
 */
@property (strong, nonatomic)NSArray *imgextra;
@property (copy, nonatomic) NSString *photosetID;
@property (copy, nonatomic)NSNumber *hasHead;
@property (copy, nonatomic)NSNumber *hasImg;
@property (copy, nonatomic) NSString *lmodify;
@property (copy, nonatomic) NSString *template;
@property (copy, nonatomic) NSString *skipType;
/**
 *  跟帖人数
 */
@property (copy, nonatomic)NSNumber *replyCount;
@property (copy, nonatomic)NSNumber *votecount;
@property (copy, nonatomic)NSNumber *voteCount;

@property (copy, nonatomic) NSString *alias;
/**
 *  新闻ID
 */
@property (copy, nonatomic) NSString *docid;
@property (assign, nonatomic) BOOL hasCover;
@property (copy, nonatomic)NSNumber *hasAD;
@property (copy, nonatomic)NSNumber *priority;
@property (copy, nonatomic) NSString *cid;
@property (strong, nonatomic)NSArray *videoID;
/**
 *  图片连接
 */
@property (copy, nonatomic) NSString *imgsrc;
@property (assign, nonatomic)BOOL hasIcon;
@property (copy, nonatomic) NSString *ename;
@property (copy, nonatomic) NSString *skipID;
@property (copy, nonatomic)NSNumber *order;
/**
 *  描述
 */
@property (copy, nonatomic) NSString *digest;

@property (strong, nonatomic)NSArray *editor;


@property (copy, nonatomic) NSString *url_3w;
@property (copy, nonatomic) NSString *specialID;
@property (copy, nonatomic) NSString *timeConsuming;
@property (copy, nonatomic) NSString *subtitle;
@property (copy, nonatomic) NSString *adTitle;
@property (copy, nonatomic) NSString *url;
@property (copy, nonatomic) NSString *source;


@property (copy, nonatomic) NSString *TAGS;
@property (copy, nonatomic) NSString *TAG;
/**
 *  大图样式
 */
@property (copy, nonatomic)NSNumber *imgType;
@property (copy, nonatomic)NSArray *specialextra;


@property (copy, nonatomic) NSString *boardid;
@property (copy, nonatomic) NSString *commentid;
@property (copy, nonatomic)NSNumber *speciallogo;
@property (copy, nonatomic) NSString *specialtip;
@property (copy, nonatomic) NSString *specialadlogo;

@property (copy, nonatomic) NSString *pixel;
@property (strong, nonatomic)NSArray *applist;

@property (copy, nonatomic) NSString *wap_portal;
@property (copy, nonatomic) NSString *live_info;
@property (copy, nonatomic) NSString *ads;
@property (copy, nonatomic) NSString *videosource;

+ (instancetype)newsModelWithDict:(NSDictionary *)dict;

@end
