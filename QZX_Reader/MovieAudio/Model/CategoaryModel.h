//
//  CategoaryModel.h
//  QZX_Reader
//
//  Created by zhangsiyao on 15/9/26.
//  Copyright © 2015年 ZhangSiYao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoaryModel : NSObject

@property (strong, nonatomic) NSString *category;   //分类
@property (strong, nonatomic) NSString *coverBlurred;
@property (strong, nonatomic) NSString *coverForDetail;
@property (assign, nonatomic) NSTimeInterval date;
@property (strong, nonatomic) NSString *myDescription;
@property (assign, nonatomic) NSInteger duration;
@property (strong, nonatomic) NSString *playUrl;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *webUrl;
@property (strong, nonatomic) NSString *save;   //下载完成后 本地沙盒的路径
@property (assign, nonatomic) NSInteger progress;   //下载中的进度显示
@property (strong, nonatomic) NSString *dataPath;   //断点下载保存的沙盒路径

@end
