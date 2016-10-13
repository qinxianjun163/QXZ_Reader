//
//  SYReplyHeader.m
//  QZX_Reader
//
//  Created by zhangsiyao on 15/9/22.
//  Copyright © 2015年 ZhangSiYao. All rights reserved.
//

#import "SYReplyHeader.h"

@interface SYReplyHeader ()

@end

@implementation SYReplyHeader

//类方法快速返回热门跟帖的View
+ (instancetype)replyViewFirst {
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SYReplyHeader" owner:nil options:nil];
    return [array firstObject];
}

//类方法快速返回最新跟帖的View
+ (instancetype)replyViewLast {
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SYReplyHeader" owner:nil options:nil];
    
    return [array lastObject];
}

@end
