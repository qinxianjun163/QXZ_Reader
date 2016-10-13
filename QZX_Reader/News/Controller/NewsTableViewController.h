//
//  NewsTableViewController.h
//  QZX_Reader
//
//  Created by zhangsiyao on 15/9/14.
//  Copyright (c) 2015年 ZhangSiYao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsTableViewController : UITableViewController

//url接口
@property(copy, nonatomic) NSString *urlString;

@property (assign, nonatomic) NSInteger index;

@property (strong, nonatomic) UIScrollView *labelView;

@end
