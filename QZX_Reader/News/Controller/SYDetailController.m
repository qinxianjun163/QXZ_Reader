//
//  SYDetailController.m
//  QZX_Reader
//
//  Created by zhangsiyao on 15/9/16.
//  Copyright (c) 2015年 ZhangSiYao. All rights reserved.
//

#import "SYDetailController.h"
#import "SYDetailImageModel.h"
#import "SYDetailModel.h"
#import "SYHTTPManager.h"
#import "SYReplyModel.h"
#import "SYReplyViewController.h"
#import "LayoutMacro.h"
#import "MJExtension.h"
#import "SYCollected.h"
#import "UMSocial.h"
#import "JDStatusBarNotification.h"
#import "UIImage+SYArchver.h"

@interface SYDetailController () <UIWebViewDelegate, UIScrollViewDelegate, UMSocialUIDelegate>
{
    CGFloat oldContentOffsetX;
    CGFloat oldContentOffsetY;
    CGFloat contentOffsetX;
    CGFloat contentOffsetY;
    CGFloat newContentOffsetX;
    CGFloat newContentOffsetY;
    BOOL isCollected;
}

@property (strong, nonatomic) UIImageView *bgImageView;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIButton *replyCountBtn;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (strong, nonatomic) SYDetailModel *detailModel;

@property (strong, nonatomic) NSMutableArray *replyModels;
@property (strong, nonatomic) NSArray *news;
@property (strong, nonatomic) UIBarButtonItem *collectedBtn;
@property (strong, nonatomic) NSManagedObjectContext *context;

@end

@implementation SYDetailController


#pragma mark - 视图加载方法

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configurationView];
    self.webView.delegate = self;
    NSString *url = [NSString stringWithFormat:@"http://c.m.163.com/nc/article/%@/full.html",self.newsModel.docid];
    [[SYHTTPManager manager] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.detailModel = [SYDetailModel detailWithDic:responseObject[self.newsModel.docid]];
        [self showInWebView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        (@"Failure = %@", error);
    }];
    //跟帖
    NSString *docID = self.newsModel.docid;
    CGFloat count = [self.newsModel.replyCount intValue];
    NSString *displayCount = nil;
    if (count > 10000) {
        displayCount = [NSString stringWithFormat:@"%.1f万跟帖", count / 10000];
    } else {
        displayCount = [NSString stringWithFormat:@"%.0f跟帖", count];
    }
    [self.replyCountBtn setTitle:displayCount forState:UIControlStateNormal];
    NSString *url2 = [NSString stringWithFormat:@"http://comment.api.163.com/api/json/post/list/new/hot/%@/%@/0/10/10/2/2",self.newsModel.boardid, docID];
    [self sendRequestWithURL2:url2];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //判断收藏状态
    if ([SYCollected isCollectedByFileName:@"test" fileSign:@"title" currentSign:self.newsModel.title]) {
        self.collectedBtn.image = [UIImage imageNamed:@"collectedYellow"];
        isCollected = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.bgImageView.image = [UIImage getImageWithSavePhotoName:@"bgPhoto.jpg"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:YES animated:YES];
}

#pragma mark - 懒加载方法

- (NSMutableArray *)replyModels {
    if (_replyModels == nil) {
        _replyModels = [NSMutableArray array];
    }
    return _replyModels;
}

- (NSArray *)news {
    if (_news == nil) {
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(9, 1, 1) lastObject];
        NSString *filePath = [docPath stringByAppendingPathComponent:@"NoneSelectURL.plist"];
        _news = [NSArray arrayWithContentsOfFile:filePath];
    }
    return _news;
}


#pragma mark - 事件响应方法

- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)uptopClick {
    [self.webView.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)shareClick {
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"55ffbd59e0f55afb5b000415"
                                      shareText:[NSString stringWithFormat:@"标题：%@\n链接地址：%@", self.newsModel.title, self.newsModel.url]
                                     shareImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.newsModel.imgsrc]]]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina, UMShareToTencent, UMShareToWechatSession, UMShareToWechatTimeline, UMShareToQzone, UMShareToQQ, UMShareToRenren, UMShareToDouban, UMShareToEmail, UMShareToSms, UMShareToFacebook, UMShareToTwitter, nil]
                                       delegate:self];
}

- (void)collectedClick {
    if (!isCollected) {
        //收藏
        [SYCollected collectedByFileName:@"test" WithDictionary:self.newsModel.keyValues];
        self.collectedBtn.image = [UIImage imageNamed:@"collectedYellow"];
        isCollected = YES;
    } else {
        //取消收藏
        [SYCollected cancelCollectedByFileName:@"test" fileSign:@"title" currentSign:self.newsModel.title];
        self.collectedBtn.image = [UIImage imageNamed:@"collected"];
        isCollected = NO;
    }
}


#pragma mark - 调用方法

- (void)configurationView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    //webView配置
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    self.webView.scrollView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
    self.webView.scrollView.shouldGroupAccessibilityChildren = YES;
    self.webView.scrollView.delegate = self;
    //蒙版视图
    self.view.backgroundColor = [UIColor clearColor];
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.opaque = NO;
    self.bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgImage"]];
    self.bgImageView.image = [UIImage getImageWithSavePhotoName:@"bgPhoto.jpg"];
    self.bgImageView.frame = self.view.bounds;
    [self.view addSubview:self.bgImageView];
    [self.view sendSubviewToBack:self.bgImageView];
    UIVisualEffectView *visualEfView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    visualEfView.frame = self.view.bounds;
    [self.bgImageView addSubview:visualEfView];
    self.titleLabel.text = self.newsModel.title;
    self.titleLabel.textColor = [UIColor colorWithRed:189 / 255.0 green:161 / 255.0 blue:69 / 255.0 alpha:1.0];
    self.headView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    //toolBar配置
    self.navigationController.toolbar.backgroundColor = [UIColor clearColor];
    self.navigationController.toolbar.barStyle = UIBarStyleBlack;
    self.navigationController.toolbarHidden = NO;
    self.navigationController.toolbar.tintColor = [UIColor colorWithRed:189 / 255.0 green:161 / 255.0 blue:69 / 255.0 alpha:1.0];
    //toolBar创建
    UIBarButtonItem *emptyItem = [[UIBarButtonItem alloc] initWithTitle:@"  " style:UIBarButtonItemStylePlain target:self action:nil];
    UIBarButtonItem *uptopBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"uptop"] style:UIBarButtonItemStylePlain target:self action:@selector(uptopClick)];
    UIBarButtonItem *shareBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStylePlain target:self action:@selector(shareClick)];
    self.collectedBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"collected"] style:UIBarButtonItemStylePlain target:self action:@selector(collectedClick)];
    self.toolbarItems = @[emptyItem ,uptopBtn, emptyItem ,shareBtn, emptyItem ,self.collectedBtn ,emptyItem];
}

//发送评论请求
- (void)sendRequestWithURL2:(NSString *)url {
    [[SYHTTPManager manager] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject[@"hotPosts"] != [NSNull null]) {
            NSArray *dicArray = responseObject[@"hotPosts"];
            for (int i = 0; i < dicArray.count; i++) {
                NSDictionary *dic = dicArray[i][@"1"];
                SYReplyModel *replyModel = [SYReplyModel new];
                replyModel.name = dic[@"n"];
                if (replyModel.name == nil) {
                    replyModel.name = @"独孤至尊";
                }
                replyModel.address = dic[@"f"];
                replyModel.say = dic[@"b"];
                replyModel.suppose = dic[@"v"];
                [self.replyModels addObject:replyModel];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        (@"Failure = %@", error);
    }];
}

- (NSString *)touchBody {
    NSMutableString *body = [NSMutableString string];
    [body appendFormat:@"<div class=\"title\">%@</div>", self.detailModel.title];
    [body appendFormat:@"<div class=\"time\">%@</div>", self.detailModel.ptime];
    if (self.detailModel.body != nil) {
        [body appendString:self.detailModel.body];
    }
    //遍历img
    for (SYDetailImageModel *detailImageModel in self.detailModel.img) {
        NSMutableString *imageHTML = [NSMutableString string];
        //设置img的div
        [imageHTML appendString:@"<div class=\"img-parent\">"];
        //数组存放被切割的像素
        NSArray *pixel = [detailImageModel.pixel componentsSeparatedByString:@"*"];
        CGFloat width = [[pixel firstObject] floatValue];
        CGFloat height = [[pixel lastObject] floatValue];
        //判断是否超过最大宽度
        CGFloat manWidth = [UIScreen mainScreen].bounds.size.width * 0.96;
        if (width > manWidth) {
            height = manWidth / width * height;
            width = manWidth;
        }
        NSString *onload = @"this.onclick = function() {"
        "  window.location.href = 'sx:src=' +this.src;"
        "};";
        [imageHTML appendFormat:@"<p style=\"text-align:center\"><img onload=\"%@\" width=\"%f\" height=\"%f\" src=\"%@\"></p>",onload,width,height,detailImageModel.src];
        //标记结束
        [imageHTML appendString:@"</div>"];
        //替换标记
        [body replaceOccurrencesOfString:detailImageModel.ref withString:imageHTML options:NSCaseInsensitiveSearch range:NSMakeRange(0, body.length)];
    }
    return body;
}

//保存到相册的方法
- (void)savePictureToAlbum:(NSString *)src {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"将要保存到本地相册" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSURLCache *cache = [NSURLCache sharedURLCache];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:src]];
        NSData *imageData = [cache cachedResponseForRequest:request].data;
        UIImage *image = [UIImage imageWithData:imageData];
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);   //保存到相册方法
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo {
    [JDStatusBarNotification showWithStatus:@"😍已经保存到照片"
                               dismissAfter:2.0
                                  styleName:JDStatusBarStyleSuccess];
}


#pragma mark - 拼接html语言

- (void)showInWebView {
    NSMutableString *html = [NSMutableString string];
    [html appendString:@"<html>"];
    [html appendString:@"<head>"];
    [html appendFormat:@"<link rel=\"stylesheet\" href=\"%@\">",[[NSBundle mainBundle] URLForResource:@"SXDetails.css" withExtension:nil]];
    [html appendString:@"</head>"];
    [html appendString:@"<body>"];
    [html appendString:[self touchBody]];
    [html appendString:@"</body>"];
    [html appendString:@"</html>"];
    
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd] == NO)
    {
        [scanner scanUpToString:@"<div class=\"title\">" intoString:nil];
        [scanner scanUpToString:@"</div>" intoString:&text];
        html = (NSMutableString *)[html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@", text] withString:@""];
        [scanner scanUpToString:@"<div class=\"time\">" intoString:nil];
        [scanner scanUpToString:@"</div>" intoString:&text];
        html = (NSMutableString *)[html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@", text] withString:@""];
    }
    [self.webView loadHTMLString:html baseURL:nil];
}

//发出通知时调用
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *url = request.URL.absoluteString;
    NSRange range = [url rangeOfString:@"sx:src="];
    if (range.location != NSNotFound) {
        NSInteger begin = range.location + range.length;
        NSString *src = [url substringFromIndex:begin];
        [self savePictureToAlbum:src];
        return NO;
    }
    return YES;
}


#pragma mark - Sroryboard跳转的segue方法

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SYReplyViewController *replyVC = segue.destinationViewController;
    replyVC.replyArray = self.replyModels;
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"contentStart" object:nil]];
}


#pragma mark - UIScrollView Delegate

//开始拖拽视图
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    contentOffsetY = scrollView.contentOffset.y;
}

// 滚动时调用此方法(手指离开屏幕后)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    newContentOffsetY = scrollView.contentOffset.y;
    if (newContentOffsetY > oldContentOffsetY && oldContentOffsetY > contentOffsetY) {  // 向上滚动
    } else if (newContentOffsetY < oldContentOffsetY && oldContentOffsetY < contentOffsetY) { // 向下滚动
        [self.navigationController setToolbarHidden:NO animated:YES];
    } else {    //正在滑动
    }
    if (scrollView.dragging) {  // 拖拽
        if ((scrollView.contentOffset.y - contentOffsetY) > 5.0f) { // 向上拖拽
            [self.navigationController setToolbarHidden:YES animated:YES];
        }
        else if ((contentOffsetY - scrollView.contentOffset.y) > 5.0f) {  // 向下拖拽
        }
    }
}

// 完成拖拽(滚动停止时调用此方法，手指离开屏幕前)
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    oldContentOffsetY = scrollView.contentOffset.y;
}

@end