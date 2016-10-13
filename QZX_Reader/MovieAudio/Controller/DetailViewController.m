//
//  DetailViewController.m
//  QZX_Reader
//
//  Created by zhangsiyao on 15/9/26.
//  Copyright © 2015年 ZhangSiYao. All rights reserved.
//

#import "DetailViewController.h"
#import "MoviePlayerController.h"
#import "DetailView.h"
#import "AppDelegate.h"
#import "UMSocial.h"
#import "DB.h"

@interface DetailViewController () <DetailViewDelegate, UIApplicationDelegate, UMSocialUIDelegate>

@end

@implementation DetailViewController


#pragma mark - 视图加载方法

- (void)viewDidLoad {
    [super viewDidLoad];
    DetailView *detailView = [[DetailView alloc] initWithFrame:self.view.bounds];
    detailView.model = self.model;
    detailView.delegate = self;
    [self.view addSubview:detailView];
    self.navigationItem.titleView.tintColor = [UIColor colorWithRed:189 / 255.0 green:161 / 255.0 blue:69 / 255.0 alpha:1.0];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.view.clipsToBounds = YES;
}


#pragma mark - 调用方法

- (void)share {
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"55ffbd59e0f55afb5b000415"
                                      shareText:[NSString stringWithFormat:@"标题：%@\n链接地址：%@", self.model.title, self.model.webUrl]
                                     shareImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.model.coverBlurred]]]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina, UMShareToTencent, UMShareToWechatSession, UMShareToWechatTimeline, UMShareToQzone, UMShareToQQ, UMShareToRenren, UMShareToDouban, UMShareToEmail, UMShareToSms, UMShareToFacebook, UMShareToTwitter, nil]
                                       delegate:self];
}

- (void)playMovie:(CategoaryModel *)model {
    MoviePlayerController *moviePlayVC = [MoviePlayerController new];
    moviePlayVC.model = self.model;
    CategoaryModel *downloadModel = [DB findDownloadComplated:self.model.playUrl];
    if (downloadModel != nil) {
        moviePlayVC.model = downloadModel;
    }
    AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
    appdelegate.isRotation = YES;
    [self presentViewController:moviePlayVC animated:YES completion:nil];
}

@end
