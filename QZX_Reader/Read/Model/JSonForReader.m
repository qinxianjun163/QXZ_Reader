//
//  JSonForReader.m
//  ReaderThreeTest
//
//  Created by 肖冯敏 on 15/9/18.
//  Copyright (c) 2015年 o‘clock. All rights reserved.
//

#import "JSonForReader.h"

@implementation JSonForReader

//创建一个文件路径
+ (NSString *)filePathWithFileName:(NSString *)fileName {
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(9, 1, 1) lastObject];
    NSString *filePath = [docPath stringByAppendingPathComponent:fileName];
    return filePath;
}

//归档 who代表调用他的uiVC //因为归档完成, 不需要返回值....// 这里返回一个BOOL证明归档完成  避免类方法 没有意义
+ (BOOL)archiver:(NSData *)data {
    
    NSMutableData *mData = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:mData];
    
    //归档过程中, 给参与归档的模型对象一个标记
    [archiver encodeObject:data forKey:@"totalData"];
    //...etc
    [archiver finishEncoding];
    
    //归档完成后 将mData 写入文件  没有创建一个新的mData, 有的覆盖 二进制文件 不能打开
    [mData writeToFile:[self filePathWithFileName:@"totalData.data"] atomically:YES];
    
    return YES;
}

//反归档
+ (NSData *)deArchiver {
    //获得存储在沙盒路径下地二进制流文件, 里面保存所有NSData 对象,
    NSData *data = [NSData dataWithContentsOfFile:[self filePathWithFileName:@"totalData.data"]];
    //反归档类 叫做NSKeyedUnarcheiver , TA 的作用是将NSData 还原成模型对象
    NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSData *totalData = [unArchiver decodeObjectForKey:@"totalData"];
    return totalData;
}



@end
