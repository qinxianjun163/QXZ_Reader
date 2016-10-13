//
//  DB.h
//  Eyes
//
//  Created by lanou3g on 15/9/21.
//  Copyright (c) 2015年 QXL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CategoaryModel.h"
#import "AudioMovieCollection.h"

@interface DB : NSObject

//关闭数据库
+ (void)close;

// 返回所有下载完成的TodayModel
+ (NSArray *)allDownloadComplated;

//添加一条下载完成的数据
+ (void)insertDownloadComplated:(CategoaryModel *)model;

//根据url删除一个下载完成的数据
+ (void)deleteDownloadComplated:(NSString *)url;

//根据url找到一个下载完成的数据
+ (CategoaryModel *)findDownloadComplated:(NSString *)url;

//返回所有正在下载的
+ (NSArray *)allDownloading;

//插入一条正在下载的
+ (void)insertDownloading:(CategoaryModel *)model;

//删除一个正在下载的
+ (void)deleteDownloading:(NSString *)url;

//查找一个正在下载的
+ (CategoaryModel *)findDownloading:(NSString *)url;

//更新一个正在下载的数据
+ (void)updateDownloading:(int)proress dataPath:(NSString *)dataPath URL:(NSString *)url;

//返回所有收藏的数据
+ (NSArray *)allMovieCollection;

//添加一个收藏的数据
+ (void)insertMovieCollection:(CategoaryModel *)model;

//删除一个收藏的数据
+ (void)deleteMovieCollection:(NSString *)url;

//查找一个收藏的数据
+ (CategoaryModel *)findMovieCollection:(NSString *)url;


@end
