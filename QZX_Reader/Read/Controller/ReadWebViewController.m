//
//  ReadWebViewController.m
//  QZX_Reader
//
//  Created by 肖冯敏 on 15/10/5.
//  Copyright © 2015年 ZhangSiYao. All rights reserved.
//

#import "ReadWebViewController.h"
#import "MyWebView.h"
#import "LayoutMacro.h"
#import "CollectionReader.h"
#import "JDStatusBarNotification.h"

@interface ReadWebViewController () <MyWebViewDelegate, UIWebViewDelegate>

@property (nonatomic, strong) MyWebView *myWebView;
@property (nonatomic, strong) NSManagedObjectContext *collectContext;

@end

@implementation ReadWebViewController

- (void)loadView {
    //读取界面 ---  v.2
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"load" ofType:@"png"];    //获得本地图片的路径
    NSString *strTemp = [NSString stringWithFormat:@"<img src=file://%@  height=%f width=%f />", imagePath, kScreenHeight, kScreenWidth - 10];  //写css
    [self.myWebView loadHTMLString:strTemp baseURL:nil];
    self.myWebView = [[MyWebView alloc] initWithFrame:CGRectZero];
    self.myWebView.delegate = self;
    self.myWebView.delegate_ = self;
    self.myWebView.scrollView.showsHorizontalScrollIndicator = NO;
    self.view = self.myWebView;
    self.myWebView.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.myWebView.collectButton];
    [CollectionReader creatCollectionWithContext:self.collectContext];
    [self request];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (NSManagedObjectContext *)collectContext {
    if (!_collectContext) {
        self.collectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    }
    return _collectContext;
}

- (void)collection {
    if (![CollectionReader isExist:self.model.title WithContext:self.collectContext]) {
        [CollectionReader addCollectionByModel:(ReadDetailModel *)self.model WithContext:self.collectContext];
        self.myWebView.collectButton.selected = YES;
    } else {
        ReadDetailModel *model = (ReadDetailModel *)self.model;
        [CollectionReader deleteCollectionByModel:model WithContext:self.collectContext];
        self.myWebView.collectButton.selected = NO;
    }
}

- (void)popBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)request {
    NSString *urlStr;
    urlStr = [NSString stringWithFormat:@"http://c.3g.163.com/nc/article/%@/full.html", self.model.docid];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    //数据库, 判断是否存在
    if ([CollectionReader isExist:self.model.title WithContext:self.collectContext]) {
        self.myWebView.collectButton.selected = YES;
    }
    else {
        self.myWebView.collectButton.selected = NO;
    }
    [self.myWebView loadHTMLString:nil baseURL:nil];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
        }
        else {    //获得的是一个model 这里对model进行图文混编
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            self.myWebView.dic = [dic objectForKey:self.model.docid];
            [self.myWebView loadMyWebView];
        }
    }];
    [dataTask resume];
}


#pragma mark - 下载图片代理方法

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

//保存完毕后调用
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    [JDStatusBarNotification showWithStatus:@"😍已经保存到照片"
                               dismissAfter:2.0
                                  styleName:JDStatusBarStyleSuccess];
}

@end
