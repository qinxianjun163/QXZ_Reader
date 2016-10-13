//
//  SYCreatKVNProgressUI.h
//  QZX_Reader
//
//  Created by zhangsiyao on 15/9/24.
//  Copyright © 2015年 ZhangSiYao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KVNProgress.h"

@interface SYCreatKVNProgressUI : NSObject

+ (void)createKVNProgress;
+ (void)setupBaseKVNProgressUI;
+ (void)setupCustomKVNProgressUI;
+ (void)updateProgress;

@end
