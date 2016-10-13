//
//  DetailViewController.h
//  QZX_Reader
//
//  Created by zhangsiyao on 15/9/26.
//  Copyright © 2015年 ZhangSiYao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoaryModel.h"

@interface DetailViewController : UIViewController

@property (strong, nonatomic) CategoaryModel *model;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIPageControl *pageView;

@property (assign, nonatomic) BOOL isToday;
@property (assign, nonatomic) BOOL isCollection;

//左滑加载更多的接口
@property (strong, nonatomic) NSString *nextPageUrl;

@end
