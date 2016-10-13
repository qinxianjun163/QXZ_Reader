//
//  MovieAudioNavigationController.m
//  QZX_Reader
//
//  Created by zhangsiyao on 15/9/9.
//  Copyright (c) 2015年 ZhangSiYao. All rights reserved.
//

#import "MovieNavigationController.h"
#import "LayoutMacro.h"
#import "ThemeColor.h"
#import "DownloadViewController.h"

@interface MovieNavigationController ()

@property (strong, nonatomic) UIButton *cacheBtn;

@end

@implementation MovieNavigationController

static NSString *reuserIdentifier = @"DownloadViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.barStyle = UIBarStyleBlackOpaque;
    self.navigationBar.tintColor = kThemeColor;
    
    self.cacheBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.cacheBtn.frame = CGRectMake(kScreenWidth - 64, 20, 55, 45);
    self.cacheBtn.tintColor = kThemeColor;
    [self.cacheBtn setTitle:@"Cache" forState:UIControlStateNormal];
    self.cacheBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.cacheBtn addTarget:self action:@selector(cacheClick) forControlEvents:UIControlEventTouchUpInside];
    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
    [window addSubview:self.cacheBtn];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.cacheBtn.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.cacheBtn.hidden = YES;
}

- (void)cacheClick {
    DownloadViewController *downloadVC = [DownloadViewController new];
    UINavigationController *downloadNC = [[UINavigationController alloc] initWithRootViewController:downloadVC];
    [self presentViewController:downloadNC animated:YES completion:nil];
}

@end
