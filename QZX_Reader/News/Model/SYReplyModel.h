//
//  SYReplyModel.h
//  QZX_Reader
//
//  Created by zhangsiyao on 15/9/22.
//  Copyright © 2015年 ZhangSiYao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYReplyModel : NSObject

/** 用户的姓名 */
@property(copy, nonatomic) NSString *name;
/** 用户的ip信息 */
@property(copy, nonatomic) NSString *address;
/** 用户的发言 */
@property(copy, nonatomic) NSString *say;
/** 用户的点赞 */
@property(copy, nonatomic) NSString *suppose;

@end
