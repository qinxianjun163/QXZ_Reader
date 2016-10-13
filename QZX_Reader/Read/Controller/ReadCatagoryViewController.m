//
//  ReadCatagoryViewController.m
//  ReaderThreeTest
//
//  Created by 肖冯敏 on 15/9/15.
//  Copyright (c) 2015年 o‘clock. All rights reserved.
//

#import "ReadCatagoryViewController.h"
#import "LayoutMacro.h"
#import "HeightForHeaderSingleton.h"
#import "ReadDetailModel.h"
#import "ReadListCell.h"
#import "ReadListLongCell.h"
#import "ReadListPortaitCell.h"
#import "SubscriptionReader.h"
#import <CoreData/CoreData.h>   //应该写在WEBView中..然而并不能
#import "CollectionReader.h"
#import "MyWebView.h"
#import "UIView+Frame.h"
#import "ReadWebViewController.h"
#import "HeaderHeight.h"
#import "ThemeColor.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "JDStatusBarStyle.h"
#import "JDStatusBarView.h"
#import "JDStatusBarNotification.h"


@interface ReadCatagoryViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ReadHeaderViewDelegate>

@property (nonatomic, strong) NSManagedObjectContext *context;  //coreData 管理
@property (nonatomic, strong) NSManagedObjectContext *collectContext;   //coreData 管理

@property (nonatomic, strong) UICollectionView *readCollectionView; //headerView之外的collectionView
@property (nonatomic, strong) NSMutableArray *dataArray;  //存放 解析出来的数据
@property (nonatomic, strong) ReadHeaderView *headerView;  //headerView 内容的部分中的model需要被访问

@property (nonatomic, strong) UIImageView *cirView;    //小黑块, 刷新的模型 (待改进) - 写字
@property (nonatomic, strong) MyWebView *myWebView;

@property (nonatomic, assign) BOOL isUpRefresh; //判断是否上啦加载
@property (nonatomic, assign) BOOL isRefreshing; //判断是否正在刷新
@property (nonatomic, strong) NSMutableString *htmlStr;

//小菊花
@property (nonatomic, assign) UIActivityIndicatorView *activityView;

@property (nonatomic, strong) UIColor *cellColor;

//做详情页面.

@end

@implementation ReadCatagoryViewController

static int num = 20; //默认的加载的阅读条数


//小菊花 回弹设置 速度, 回弹 的时候用 DY动画.
//static float vec = 0;

//Cell的重用标识符
static NSString * const reuseCell = @"ReadListCell";
static NSString * const reuseLongCell = @"ReadLongCell";
static NSString * const reusePorataitCell = @"ReadPoraitCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];   //改变颜色
    //webView 先创建 但是满暂时不添加上去, 当数据加载好了 再添加上去
    self.myWebView = [[MyWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    //初始会有一次数据加载, 所以要设置初始值为正在刷新
    self.isRefreshing = YES;
    //在这里创建一个单例 用于时时接受属性 - (这里在重构界面后其实已经不需要了, 没有涉及数据reloadData 所以这里其实用一个属性 传值就可以了)
    HeightForHeaderSingleton *singleton = [HeightForHeaderSingleton shareInstance];
    //创建标题视图
    [self creatHeadView:singleton];
    //创建内容视图,用于存放每条文章
    [self creatReadCollectionView:singleton];
    //coreData部分 懒加载 coreDataContext
    [SubscriptionReader creatSubscriptionWithContext:self.context];
    [CollectionReader creatCollectionWithContext:self.collectContext];
    if ([SubscriptionReader isExist:self.model.tid WithContext:self.context]) {
        self.headerView.subscriptionButton.selected = YES;
    }
    else {
        self.headerView.subscriptionButton.selected = NO;
    }
    [self requestByUrl];
    //注册cell
    [self.readCollectionView registerClass:[ReadListCell class] forCellWithReuseIdentifier:reuseCell];
    [self.readCollectionView registerClass:[ReadListLongCell class] forCellWithReuseIdentifier:reuseLongCell];
    [self.readCollectionView registerClass:[ReadListPortaitCell class] forCellWithReuseIdentifier:reusePorataitCell];
    //下拉加载
    [self.readCollectionView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [self.readCollectionView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}


- (void)requestByUrl {
    self.activityView.hidden = NO;
    NSString *tid = self.model.tid;
    if (self.isUpRefresh) {
        num = (int)self.dataArray.count + 5;
    } else {
        num = 20;
    }
    NSString *strURL = [NSString stringWithFormat:@"http://c.3g.163.com/nc/article/list/%@/0-%d.html", tid, num];
    //网络请求
    NSURL *url = [NSURL URLWithString:strURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
        } else {
            if (!self.isUpRefresh) {
                [self.readCollectionView .header endRefreshing];
            }else [self.readCollectionView.footer endRefreshing];
            self.isUpRefresh = NO;
            if (num != self.dataArray.count) {
                [JDStatusBarNotification showWithStatus:@"✔︎已经刷新"
                                           dismissAfter:2.0
                                              styleName:JDStatusBarStyleSuccess];
            }
            self.dataArray = [NSMutableArray array];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            for (NSDictionary *detailDic in dic[self.model.tid]) {
                ReadDetailModel *model = [[ReadDetailModel alloc] initWithDictionary:detailDic];
                [self.dataArray addObject:model];
            }
            if (num != self.dataArray.count) {
                [self.readCollectionView.footer noticeNoMoreData];
            }
        }
        [self.readCollectionView reloadData];
        self.activityView.hidden = YES;

    }];
}

#pragma mark - 刷新执行的方法
- (void)loadMoreData {
    self.isUpRefresh = YES;
    [self requestByUrl];
    [self.readCollectionView.footer beginRefreshing];
}

- (void)loadData {
    self.isUpRefresh = NO;
    [self requestByUrl];
}



#pragma mark - 懒加载

- (NSManagedObjectContext *)context {
    if (!_context) {
        self.context = [NSManagedObjectContext new];
    }
    return _context;
}

- (NSManagedObjectContext *)collectContext {
    if (!_collectContext) {
        self.collectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    }
    return _collectContext;
}

//数据存储
- (void)collection:(UIButton *)button {
    if (![CollectionReader isExist:self.myWebView.model.title WithContext:self.collectContext]) {
        [CollectionReader addCollectionByModel:self.myWebView.model WithContext:self.collectContext];
        self.myWebView.collectButton.selected = YES;
    } else {
        [CollectionReader deleteCollectionByModel:self.myWebView.model WithContext:self.collectContext];
        self.myWebView.collectButton.selected = NO;
    }
}

//创建标签视图
- (void)creatHeadView:(HeightForHeaderSingleton *)singleton {
    self.headerView = [[ReadHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kHeaderHeight)];
    self.headerView.tname = self.model.tname;
    self.headerView.tid = self.model.tid;
    self.cellColor = [self.headerView createImageView];
    self.headerView.titleLabel.text = self.model.tname;
    self.headerView.describeLabel.text = [NSString stringWithFormat:@"––– %@ –––­­", self.model.alias];
    self.headerView.delegate = self;
    [self.headerView.backButton addTarget:self action:@selector(dismissToPrevView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.headerView];
}

//创建内容视图
- (void)creatReadCollectionView:(HeightForHeaderSingleton *)singleton {
    //内容视图的flowLayouot
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(kScreenWidth - 10, kScreenHeight / 5);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 5;
    
    self.readCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kHeaderHeight, kScreenWidth, kScreenHeight - kHeaderHeight) collectionViewLayout:flowLayout];
    self.readCollectionView.contentSize = self.readCollectionView.frame.size;
    self.readCollectionView.alwaysBounceVertical = YES;
    //设置代理 和数据接受者
    self.readCollectionView.delegate = self;
    self.readCollectionView.dataSource = self;
    self.readCollectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.readCollectionView];
}


#pragma mark - 代理执行的收藏方法

- (void)subscription:(UIButton *)button {
    ReadListModel *model = self.model;
    if ([SubscriptionReader isExist:model.tid WithContext:self.context]) {
        [SubscriptionReader deleteSubscriptionByModel:model WithContext:self.context];
        self.headerView.subscriptionButton.selected = NO;
    }
    else {
        [SubscriptionReader addSubscriptionByModel:model WithContext:self.context];
        self.headerView.subscriptionButton.selected = YES;
    }
}

- (void)removeSub:(removeSub)superIndexPath {
    self.removeSub = superIndexPath;
}

- (void)dismissToPrevView:(UIButton *)button {
    HeightForHeaderSingleton *singleton = [HeightForHeaderSingleton shareInstance];
    singleton.height = 0;
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ReadDetailModel *model = self.dataArray[indexPath.row];
    // 先判断是否两倍宽度, 否再判读 图片方向.
    // pixel 有的没有.
    NSArray *array = [model.pixel componentsSeparatedByString:@"*"];
    CGFloat imageWidth = [array[0] floatValue];
    CGFloat imageHeight = [array[1] floatValue];
    BOOL isScaleH = imageWidth > imageHeight ? YES : NO;
    
    if (imageWidth > 1.5 * imageHeight || !model.pixel) {   //全图cell
        ReadListLongCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseLongCell forIndexPath:indexPath];
        cell.backgroundColor = [self.cellColor colorWithAlphaComponent:((arc4random() % 128) + 128) / 255.0];
        cell.model = self.dataArray[indexPath.row];
        return cell;
    } else if (isScaleH) {  //左图cell
        ReadListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseCell forIndexPath:indexPath];
        cell.backgroundColor = [self.cellColor colorWithAlphaComponent:((arc4random() % 128) + 128) / 255.0];
        cell.model = self.dataArray[indexPath.row];
        return cell;
    } else {    //右图cell
        ReadListPortaitCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reusePorataitCell forIndexPath:indexPath];
        cell.backgroundColor = [self.cellColor colorWithAlphaComponent:(arc4random() % 256) / 255.0];
        cell.model = self.dataArray[indexPath.row];
        return cell;
    }
}


#pragma mark - 改变位置的方法

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    HeightForHeaderSingleton *singleton = [HeightForHeaderSingleton shareInstance];
    singleton.height = self.readCollectionView.contentOffset.y;
    //    改变header的方法.
    self.headerView.frame = CGRectMake(0, 0, kScreenWidth, MIN(kHeaderHeight, MAX(64, kHeaderHeight - singleton.height)));
    [self.headerView updateHeaderView];
    //改变collectionView的布局
    self.readCollectionView.frame = CGRectMake(0, MIN(kHeaderHeight, MAX(64, kHeaderHeight - singleton.height)), kScreenWidth, kScreenHeight - MIN(kHeaderHeight, MAX(64, kHeaderHeight - singleton.height)));
    self.readCollectionView.backgroundColor = [UIColor clearColor];
}


#pragma mark - 详情界面BUG - 图片大小未设置

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ReadWebViewController *readWebVC = [[ReadWebViewController alloc] init];
    ReadDetailModel *model = self.dataArray[indexPath.row];
    readWebVC.model = (CollectionModel *)model;
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    titleView.textAlignment = NSTextAlignmentCenter;
    titleView.text = model.source;
    titleView.font = [UIFont boldSystemFontOfSize:18];
    titleView.textColor = kThemeColor;
    readWebVC.navigationItem.titleView = titleView;
    [self.navigationController pushViewController:readWebVC animated:YES];
}

@end
