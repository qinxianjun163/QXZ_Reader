//
//  SYCollected.m
//  QZX_Reader
//
//  Created by zhangsiyao on 15/9/21.
//  Copyright © 2015年 ZhangSiYao. All rights reserved.
//

#import "SYCollected.h"

@implementation SYCollected

+ (BOOL)isCollectedByFileName:(NSString *)fileName fileSign:(NSString *)fileSign currentSign:(NSString *)currentSign {
    NSString *doc = [NSSearchPathForDirectoriesInDomains(9, 1, 1) lastObject];
    NSString *filePath = [doc stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", fileName]];
    NSMutableArray *modelArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    for (NSDictionary *dic in modelArray) {
        if ([[dic valueForKey:fileSign] isEqualToString:currentSign]) {
            return YES;
        }
    }
    return NO;
}

+ (void)collectedByFileName:(NSString *)fileName WithDictionary:(NSDictionary *)dic {
    NSString *doc = [NSSearchPathForDirectoriesInDomains(9, 1, 1) lastObject];
    NSString *filePath = [doc stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", fileName]];
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:filePath]) {
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
        [manager copyItemAtPath:bundlePath toPath:filePath error:nil];
    }
    NSMutableArray *modelArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    if (modelArray == nil) {
        modelArray = [NSMutableArray array];
    }
    [modelArray addObject:dic];
    [modelArray writeToFile:filePath atomically:NO];
}

+ (void)cancelCollectedByFileName:(NSString *)filename fileSign:(NSString *)fileSign currentSign:(NSString *)currentSign {
    NSString *doc = [NSSearchPathForDirectoriesInDomains(9, 1, 1) lastObject];
    NSString *filePath = [doc stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", filename]];
    NSMutableArray *modelArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    int index = 0;
    for (NSDictionary *dic in modelArray) {
        if ([[dic valueForKey:fileSign] isEqualToString:currentSign]) {
            break;
        }
        index++;
    }
    [modelArray removeObjectAtIndex:index];
    [modelArray writeToFile:filePath atomically:NO];
}

+ (void)historyReadByFileName:(NSString *)fileName WithInfo:(id)info {
    NSString *doc = [NSSearchPathForDirectoriesInDomains(9, 1, 1) lastObject];
    NSString *filePath = [doc stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", fileName]];
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:filePath]) {
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
        [manager copyItemAtPath:bundlePath toPath:filePath error:nil];
    }
    NSMutableArray *modelArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    if (modelArray == nil) {
        modelArray = [NSMutableArray array];
    }
    [modelArray addObject:info];
    [modelArray writeToFile:filePath atomically:NO];
}

@end
