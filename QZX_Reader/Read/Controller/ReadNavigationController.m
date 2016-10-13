//
//  ReadNavigationController.m
//  QZX_Reader
//
//  Created by zhangsiyao on 15/9/14.
//  Copyright (c) 2015年 ZhangSiYao. All rights reserved.
//

#import "ReadNavigationController.h"
#import "ThemeColor.h"

@interface ReadNavigationController ()

@end

@implementation ReadNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.barStyle = UIBarStyleBlackOpaque;
    self.navigationBar.tintColor = kThemeColor;
}

@end
