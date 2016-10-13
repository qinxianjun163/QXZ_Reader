//
//  SYPhotoViewController.h
//  QZX_Reader
//
//  Created by zhangsiyao on 15/9/17.
//  Copyright (c) 2015年 ZhangSiYao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYNewsModel.h"
#import "SYPhotoSet.h"

@interface SYPhotoViewController : UIViewController 

@property (strong, nonatomic) SYNewsModel *newsModel;
@property (strong, nonatomic) SYPhotoSet *photoSet;

@end
