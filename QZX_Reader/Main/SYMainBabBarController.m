//
//  SYMainBabBarController.m
//  QZX_Reader
//
//  Created by zhangsiyao on 15/9/14.
//  Copyright (c) 2015年 ZhangSiYao. All rights reserved.
//

#import "SYMainBabBarController.h"

@interface SYMainBabBarController ()<UITabBarControllerDelegate>

@end

@implementation SYMainBabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBar.barStyle = UIBarStyleBlackOpaque;
    self.tabBar.tintColor = [UIColor colorWithRed:189 / 255.0 green:161 / 255.0 blue:69 / 255.0 alpha:1.0];
    self.delegate = self;
    UIViewController *newsVC = self.viewControllers[0];
    newsVC.tabBarItem.image = [UIImage imageNamed:@"News"];
    UIViewController *readVC = self.viewControllers[1];
    readVC.tabBarItem.image = [UIImage imageNamed:@"Read"];
    UIViewController *movieRedioVC = self.viewControllers[2];
    movieRedioVC.tabBarItem.image = [UIImage imageNamed:@"Movie"];
    UIViewController *selfVC = self.viewControllers[3];
    selfVC.tabBarItem.image = [UIImage imageNamed:@"Self"];
}


@end
