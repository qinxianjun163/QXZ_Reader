//
//  WebViewModel.m
//  UIWebViewTWHB
//
//  Created by 肖冯敏 on 15/10/4.
//  Copyright (c) 2015年 o‘clock. All rights reserved.
//

#import "WebViewModel.h"

@implementation WebViewModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"template"]) {
        self.templateR = value;
    }
}

- (id)valueForUndefinedKey:(NSString *)key {
    return nil;
}

//装逼方法，一行代码 KVC
- (instancetype)initWithDictionary:(NSDictionary *)dic {
    if ([super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

@end
