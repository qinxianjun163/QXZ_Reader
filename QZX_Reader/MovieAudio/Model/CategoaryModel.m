//
//  CategoaryModel.m
//  QZX_Reader
//
//  Created by zhangsiyao on 15/9/26.
//  Copyright © 2015年 ZhangSiYao. All rights reserved.
//

#import "CategoaryModel.h"

@implementation CategoaryModel

//在赋值的过程中，如果发现未声明的Key
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"description"]) {
        [self setValue:value forKey:@"myDescription"];
    }
}

@end
