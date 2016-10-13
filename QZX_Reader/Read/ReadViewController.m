//
//  ReadViewController.m
//  QZX_Reader
//
//  Created by zhangsiyao on 15/9/14.
//  Copyright (c) 2015年 ZhangSiYao. All rights reserved.
//

#import "ReadViewController.h"
#import "XLPlainFlowLayout.h"
#import "CircleLayout.h"
#import "ReadRusableView.h"
#import "ReadRusebleHeaderView.h"
#import "SubscriptionController.h"
#import "JSonForReader.h"
#import "ReadCatagoryViewController.h"
#import "ReaderHeaderItemView.h"
#import "ReadSideCollectionViewController.h"
#import <CoreData/CoreData.h>
#import "SubscriptionReader.h"
#import "LayoutMacro.h"
#import "UIView+Frame.h"
#import "MJExtension.h"
#import "ThemeColor.h"
#import "JDStatusBarStyle.h"
#import "JDStatusBarView.h"
#import "JDStatusBarNotification.h"

@interface ReadViewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, ReadRusebleHeaderViewDelegate, NSURLSessionTaskDelegate, NSURLSessionDelegate, NSURLSessionDataDelegate, UIGestureRecognizerDelegate> {
    CGFloat translationY;
}

@property (nonatomic, strong) NSMutableArray *totalArray; //用于存放 请求下来的数组
@property (nonatomic, strong) NSMutableData *totalData;     //用于存发 请求下来的数据
@property (nonatomic, strong) NSMutableArray *commandArray; //存放推荐的数组(model)
@property (nonatomic, assign) CGPoint preOffset;            //layout从XLP模式转成cir(斜)模式的时候, 几率offset 返回的时候返回原来的offset
@property (nonatomic, assign) BOOL isOperationMenu; //当scroll > 一定程度的时候, 显示菜单动画, 并且可以操作手势.
@property (nonatomic, strong) ReaderHeaderItemView *headerItemView;//菜单栏目
@property (nonatomic, strong) UIView *maskView; //蒙版
@property (nonatomic, strong) NSManagedObjectContext *context;

@end

@implementation ReadViewController

static NSString * const reuseTop = @"ReadTop";  //重用cell的字段, 这个是用于 首页的第一个cell
static NSString * const reuseHeader = @"ReadHeader"; //重用cell的字段, 这个是用于 header
static NSString * const reuseItem = @"ReadItem"; //重用cell的字段, 这个是用于普通cell

- (void)loadView {
    XLPlainFlowLayout *flowLayout = [[XLPlainFlowLayout alloc] init];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    flowLayout.itemSize = CGSizeMake(width / 2, width / 2);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor whiteColor];
    
    self.collectionView = collectionView;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //创建 主页面菜单栏目
    self.headerItemView = [[ReaderHeaderItemView alloc] initWithFrame:CGRectMake(0, -84, kScreenWidth, 64)];
    self.headerItemView.alpha = 0.0;
    [self.collectionView addSubview:self.headerItemView];
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    titleView.text = @"Handpick";
    titleView.font = [UIFont fontWithName:@"SnellRoundhand-Black" size:20];
    titleView.textColor = kThemeColor;
    self.navigationItem.titleView = titleView;
    //创建 数据库
    [SubscriptionReader creatSubscriptionWithContext:self.context];
    // Register cell classes
    [self.collectionView registerClass:[ReadRusableView class] forCellWithReuseIdentifier:reuseItem];
    [self.collectionView registerClass:[ReadRusableView class] forCellWithReuseIdentifier:reuseTop];
    //注册section视图.
    [self.collectionView registerClass:[ReadRusebleHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader  withReuseIdentifier:reuseHeader];
    [self requestionBySession]; //数据请求
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = NO;
}

- (void)requestionBySession {
    if ([JSonForReader deArchiver]) {
        NSData *data = [JSonForReader deArchiver];
        self.totalArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        //这里可以添加 command数组
        self.commandArray = [NSMutableArray array];
        for (int i = 0; i < 5; i++) {
            int arcSection = arc4random() % (self.totalArray.count - 1) + 1;
            int arcRow = arc4random() % ([[self.totalArray[arcSection] objectForKey:@"tList"] count] - 1) + 1;
            [self.commandArray addObject:[[self.totalArray[arcSection] objectForKey:@"tList"] objectAtIndex:arcRow]];
        }
    } else {
        NSString *urlStr = @"http://c.m.163.com/nc/topicset/ios/v4/subscribe/read/all.html";
        NSURL *totalUrl = [NSURL URLWithString:urlStr];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        NSURLRequest *request = [NSURLRequest requestWithURL:totalUrl];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error) {
                (@"error:%@", error);
            } else {
                (@"data :%@", data);
                [self.totalData appendData:data];
            }
            [JSonForReader archiver:self.totalData];
            self.totalArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            for (int i = 0; i < 5; i++) {
                int arcSection = arc4random() % (self.totalArray.count - 1) + 1;
                int arcRow = arc4random() % ([[self.totalArray[arcSection] objectForKey:@"tList"] count] - 1) + 1;
                [self.commandArray addObject:[[self.totalArray[arcSection] objectForKey:@"tList"] objectAtIndex:arcRow]];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
        }];
        [dataTask resume];
    }
}


#pragma mark - 懒加载

- (UIView *)maskView {
    if (!_maskView) {
        self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 64, 64)];
        self.maskView.center = self.headerItemView.center;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 64, 64)];
        imageView.image = [UIImage imageNamed:@"iconfont-xuanzhongquan-2"];
        [self.maskView addSubview:imageView];
        self.maskView.alpha = 0.5;
        [self.headerItemView addSubview:self.maskView];
    }
    return _maskView;
}

- (NSManagedObjectContext *)context {
    if (!_context) {
        self.context = [[NSManagedObjectContext alloc] init];
    }
    return _context;
}

- (NSMutableArray *)commandArray {
    if (!_commandArray) {
        self.commandArray = [NSMutableArray array];
    }
    return _commandArray;
}


#pragma mark - 上方菜单栏

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat translationX = [self.collectionView.panGestureRecognizer translationInView:self.collectionView].x;
    translationY = [self.collectionView.panGestureRecognizer translationInView:self.collectionView].y;
    //最大值, 最小值. --- max min
    self.maskView.center = CGPointMake(MIN(MAX(kScreenWidth / 4, self.headerItemView.center.x + translationX), kScreenWidth / 4 * 3), self.headerItemView.center.y + 74);
    self.headerItemView.alpha = translationY / 180;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (translationY >= 180 && self.collectionView.contentOffset.y < 0) {
        if (self.maskView.center.x < kScreenWidth / 3) {
            [self turnToAllSectionSelectedViewController];
        } else if(self.maskView.center.x > kScreenWidth / 3 * 2) {
            [self turnToSubscriptionView];
        }
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    //创建 header
    if (indexPath.section == 0) {
        ReadRusebleHeaderView *header = [collectionView  dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseHeader forIndexPath:indexPath];
        //这里 设计 使 header 的颜色 在半透明蓝 和黑中切换 下同
        header.backgroundColor = [UIColor clearColor];
        header.buttonSection.tag = 1000 + indexPath.section;
        return (UICollectionReusableView *)header;
    }
    if (indexPath.section > 0) {
        ReadRusebleHeaderView *header = [collectionView  dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseHeader forIndexPath:indexPath];
        header.backgroundColor = [UIColor clearColor];
        header.buttonSection.tag = 1000 + indexPath.section;
        header.titleView.text = [self.totalArray[indexPath.section] objectForKey:@"cName"];
        int num = (int)[[self.totalArray[indexPath.section] objectForKey:@"tList"] count];
        [header.buttonSection setTitle:[NSString stringWithFormat:@"看全部%d个专题",num] forState:UIControlStateNormal];
        return (UICollectionReusableView *)header;
    }
    return nil;
}


#pragma mark - 页面跳转

- (void)turnToSubscriptionView {
    ReadSideCollectionViewController *sideVC = [[ReadSideCollectionViewController alloc] init];
    NSArray *array = [SubscriptionReader selectAllSubscriptionWithContext:self.context];
    sideVC.willShowSub = YES;
    sideVC.dataArray = (NSMutableArray *)array;
    [sideVC hidesBottomBarWhenPushed];
    
    [self.navigationController pushViewController:sideVC animated:nil];
}

//重写了layout : 产生的问题, 布局改变, 自适应 每个item 发生偏差.
- (void)turnToSelectedIndexPath:(UIButton *)button {
    ReadSideCollectionViewController *sideVC = [[ReadSideCollectionViewController alloc] init];
    CGFloat section = button.tag - 1000;
    sideVC.dataArray = [[self.totalArray objectAtIndex:section] objectForKey:@"tList"];;
    [self.navigationController pushViewController:sideVC animated:nil];
}

//切换 layout  //改正, 现在切换的是控制器
- (void)turnToAllSectionSelectedViewController {
    SubscriptionController *subscriptionVC = [[SubscriptionController alloc] init];
    [self.navigationController pushViewController:subscriptionVC animated:YES];
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.totalArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 5;
    } else {
        return 4;
    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section > 0) {
        return CGSizeMake(0, kScreenWidth / 4);
    }
    return CGSizeZero;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) { //第一个cell 不同 为top样式
        ReadRusableView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseTop forIndexPath:indexPath];
        cell.imageSrcView.x = (kScreenWidth - 100) / 2;
        cell.titleLabel.width = kScreenWidth;
        cell.model = [[ReadListModel alloc] initWithDictionary:self.commandArray[indexPath.row]];
        cell.titleLabel.text = [NSString stringWithFormat:@"%@\n特别推荐",[[ReadListModel alloc] initWithDictionary:self.commandArray[indexPath.row]].tname];
        cell.titleLabel.y = cell.height - (cell.height - 70) / 2;
        cell.titleLabel.height = (cell.height - 100) / 2;
        return cell;
    }
    else {
        ReadRusableView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseItem forIndexPath:indexPath];
        if (indexPath.section == 0) {
            cell.model = [[ReadListModel alloc] initWithDictionary:self.commandArray[indexPath.row]];
        } else {
            cell.model = [[ReadListModel alloc] initWithDictionary:[[self.totalArray[indexPath.section] objectForKey:@"tList"] objectAtIndex:indexPath.row]];
        }
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0&& indexPath.row == 0) {
        return CGSizeMake(kScreenWidth - 0.0001, kScreenWidth / 2);
    } else {
        return CGSizeMake(kScreenWidth / 2, kScreenWidth / 2);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ReadCatagoryViewController *readCatagoryVC = [[ReadCatagoryViewController alloc] init];
    if (indexPath.section == 0) {
        readCatagoryVC.model = [[ReadListModel alloc] initWithDictionary:self.commandArray[indexPath.row]];
    } else {
        readCatagoryVC.model = [[ReadListModel alloc] initWithDictionary:[[self.totalArray[indexPath.section] objectForKey:@"tList"] objectAtIndex:indexPath.row]];
    }
    [self.navigationController pushViewController:readCatagoryVC animated:YES];
}

@end
