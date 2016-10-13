//
//  ReadListModel.m
//  ReaderThreeTest
//
//  Created by 肖冯敏 on 15/9/22.
//  Copyright (c) 2015年 o‘clock. All rights reserved.
//

#import "ReadListModel.h"

@implementation ReadListModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
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
