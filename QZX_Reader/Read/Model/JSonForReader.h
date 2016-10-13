//
//  JSonForReader.h
//  ReaderThreeTest
//
//  Created by 肖冯敏 on 15/9/18.
//  Copyright (c) 2015年 o‘clock. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSonForReader : NSObject


#pragma mark - 这是对总列表的归档操作
//创建一个文件路径
+ (NSString *)filePathWithFileName:(NSString *)fileName;

//+ (NSData *)analysisForSection; //获取总的NSData

+ (BOOL)archiver:(NSData *)data;

+ (NSData *)deArchiver;
//- jsonForItem;

#pragma mark - 下面是对详情列表的操作.


@end
