//
//  ReadCatagoryViewController.h
//  ReaderThreeTest
//
//  Created by 肖冯敏 on 15/9/15.
//  Copyright (c) 2015年 o‘clock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReadHeaderView.h"
@class ReadListModel;

typedef void(^removeSub)(NSIndexPath *superIndexPath);

//显示类别详情的的VC
@interface ReadCatagoryViewController : UIViewController

@property (nonatomic, strong) ReadListModel *model;
@property (nonatomic, assign) NSIndexPath *superIndexPath;
@property (nonatomic, assign) BOOL FromSub;
@property (nonatomic, strong) removeSub removeSub;

- (void)removeSub:(removeSub)superIndexPath;

@end
