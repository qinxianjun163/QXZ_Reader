//
//  MoviePlayerController.m
//  QZX_Reader
//
//  Created by zhangsiyao on 15/10/3.
//  Copyright © 2015年 ZhangSiYao. All rights reserved.
//

#import "MoviePlayerController.h"
#import "MoviePlayer.h"
#import "AppDelegate.h"
#import "UIView+Frame.h"

@interface MoviePlayerController () <MoviePlayerDelegate>

@property (strong, nonatomic) MoviePlayer *moviePlayer;

@end

@implementation MoviePlayerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *url = nil;
    if (self.model.save) {
        // 如果我们的save有值，代表已经下载完成，url使用本地的
        url = [NSURL fileURLWithPath:self.model.save];
    }else{
        // else我们还使用网络的url
        url = [NSURL URLWithString:self.model.playUrl];
    }
    self.moviePlayer = [[MoviePlayer alloc] initWithFrame:CGRectMake(0, 0, self.view.height, self.view.width) URL:url];
    self.moviePlayer.title = self.model.title;
    self.moviePlayer.delegate = self;
    [self.view addSubview:self.moviePlayer];
}

- (void)back {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    //设置属性，让它只支持竖屏切换
    appDelegate.isRotation = NO;
    //一定要写在视图消失和加载之前.
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
