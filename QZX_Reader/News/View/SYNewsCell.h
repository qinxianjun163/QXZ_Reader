//
//  SYNewsCell.h
//  QZX_Reader
//
//  Created by zhangsiyao on 15/9/15.
//  Copyright (c) 2015年 ZhangSiYao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYNewsModel.h"

@interface SYNewsCell : UITableViewCell

@property (strong, nonatomic) SYNewsModel *newsModel;

//返回可重用的id
+ (NSString *)idForRow:(SYNewsModel *)newsModel;
//返回行高
+ (CGFloat)heightForRow:(SYNewsModel *)newsModel;

@end
