//
//  SYDetailController.h
//  QZX_Reader
//
//  Created by zhangsiyao on 15/9/16.
//  Copyright (c) 2015年 ZhangSiYao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYNewsModel.h"

@interface SYDetailController : UIViewController

@property (strong, nonatomic) SYNewsModel *newsModel;
@property (assign, nonatomic) NSInteger index;

@end
