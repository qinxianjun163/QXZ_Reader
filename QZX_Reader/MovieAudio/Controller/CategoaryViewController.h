//
//  CategoaryViewController.h
//  QZX_Reader
//
//  Created by zhangsiyao on 15/9/26.
//  Copyright © 2015年 ZhangSiYao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoaryModel.h"

@interface CategoaryViewController : UITableViewController

@property (strong, nonatomic) NSString *url;

@property (assign, nonatomic) BOOL isDetail;

@property (strong, nonatomic) CategoaryModel *model;

@property (strong, nonatomic) NSString *nextPageUrl;    //上提加载更多的借口

@end
