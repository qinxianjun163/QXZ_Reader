//
//  SYCollected.h
//  QZX_Reader
//
//  Created by zhangsiyao on 15/9/21.
//  Copyright © 2015年 ZhangSiYao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYCollected : NSObject

+ (BOOL)isCollectedByFileName:(NSString *)fileName fileSign:(NSString *)fileSign currentSign:(NSString *)currentSign;   //根据给定字段和指定文件中字段比较，判断是否收藏

+ (void)collectedByFileName:(NSString *)fileName WithDictionary:(NSDictionary *)dic;    //将字典添加到指定文件中

+ (void)cancelCollectedByFileName:(NSString *)filename fileSign:(NSString *)fileSign currentSign:(NSString *)currentSign;   //根据给定字段在指定文件中检索删除该条记录

+ (void)historyReadByFileName:(NSString *)fileName WithInfo:(id)info;   //将历史记录保存在指定文件中

@end
