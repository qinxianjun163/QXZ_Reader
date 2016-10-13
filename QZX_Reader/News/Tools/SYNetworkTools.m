//
//  SYNetworkTools.m
//  QZX_Reader
//
//  Created by zhangsiyao on 15/9/15.
//  Copyright (c) 2015年 ZhangSiYao. All rights reserved.
//

#import "SYNetworkTools.h"

@implementation SYNetworkTools

+ (instancetype)sharedNewworkTools {
    static SYNetworkTools * instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *url = [NSURL URLWithString:@"http://c.m.163.com/"];
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        instance = [[self alloc] initWithBaseURL:url sessionConfiguration:config];
        instance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    });
    return instance;
}

@end
