//
//  NewsViewController.m
//  QZX_Reader
//
//  Created by zhangsiyao on 15/9/14.
//  Copyright (c) 2015年 ZhangSiYao. All rights reserved.
//

#import "NewsViewController.h"
#import "UIView+Frame.h"
#import "NewsTableViewController.h"
#import "TitleView.h"
#import "LayoutMacro.h"
#import "UIImage+SYArchver.h"

@interface NewsViewController () <UIScrollViewDelegate>

//标题栏
@property (strong, nonatomic) IBOutlet UIScrollView *labelView;
//内容视图
@property (strong, nonatomic) IBOutlet UIScrollView *contentView;
//资讯数据
@property(strong, nonatomic) NSArray *arrayLists;

@property (strong, nonatomic) UIImageView *bgImageView;

@end

@implementation NewsViewController


#pragma mark - 视图加载方法

- (void)viewDidLoad {
    [super viewDidLoad];
    //导航栏title设置
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    titleView.text = @"News";
    titleView.font = [UIFont fontWithName:@"SnellRoundhand-Black" size:20];
    titleView.textColor = [UIColor colorWithRed:189 / 255.0 green:161 / 255.0 blue:69 / 255.0 alpha:1.0];
    self.navigationItem.titleView = titleView;
    //配置设置
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.contentView.pagingEnabled = YES;
    //隐藏滚动条否则崩溃
    self.labelView.showsHorizontalScrollIndicator = NO;
    self.labelView.showsVerticalScrollIndicator = NO;
    self.contentView.showsHorizontalScrollIndicator = NO;
    self.contentView.showsVerticalScrollIndicator = NO;
    self.contentView.delegate = self;
    self.labelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    self.contentView.backgroundColor = [UIColor clearColor];
    //方法调用
    [self copyBundle];  //拷贝文件到沙盒路径下
    self.arrayLists = [NSArray arrayWithContentsOfFile:[self copyBundle]];  //给数组赋值
    [self createContentView];   //初始化内容视图
    [self createLabel]; //初始化标签页
    //视图初始化设置
    self.contentView.contentSize = CGSizeMake(self.childViewControllers.count * [UIScreen mainScreen].bounds.size.width, 0);
    UIViewController *addVC = [self.childViewControllers firstObject];
    addVC.view.frame = self.contentView.bounds;
    [self.contentView addSubview:addVC.view];
    TitleView *firstTitle = (TitleView *)[self.labelView.subviews firstObject];
    firstTitle.scale = 1.0;
    //毛玻璃背景
    self.bgImageView = [[UIImageView alloc] initWithImage:[UIImage getImageWithSavePhotoName:@"bgPhoto.jpg"]];
    self.bgImageView.frame = self.view.bounds;
    [self.view addSubview:self.bgImageView];
    [self.view sendSubviewToBack:self.bgImageView];
    UIVisualEffectView *visualEfView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    visualEfView.frame = [UIScreen mainScreen].bounds;
    [self.bgImageView addSubview:visualEfView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.bgImageView.image = [UIImage getImageWithSavePhotoName:@"bgPhoto.jpg"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


#pragma mark - 调用方法

- (NSString *)copyBundle {
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(9, 1, 1) lastObject];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *filePath = [docPath stringByAppendingPathComponent:@"SelectURL.plist"];
    if (![fileManager fileExistsAtPath:filePath]) {
        NSString *bunlePath = [[NSBundle mainBundle] pathForResource:@"SelectURL" ofType:@"plist"];
        [fileManager copyItemAtPath:bunlePath toPath:filePath error:nil];
    }
    return filePath;
}


#pragma mark - 添加视图方法

- (void)createContentView {
    for (int i = 0; i < self.arrayLists.count; i++) {
        NewsTableViewController *contentVC = [[UIStoryboard storyboardWithName:@"News" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
        contentVC.labelView = self.labelView;
        contentVC.title = self.arrayLists[i][@"title"];
        contentVC.urlString = self.arrayLists[i][@"urlString"];
        [self addChildViewController:contentVC];
    }
}

- (void)createLabel {
    CGFloat width = 70; CGFloat height = 40; CGFloat y = 0;
    self.labelView.contentSize = CGSizeMake(70 * self.arrayLists.count, 0);
    for (int i = 0; i < self.arrayLists.count; i++) {
        CGFloat x = width * i;
        NSDictionary *imageName = self.arrayLists[i];
        TitleView *titleView = [[TitleView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        titleView.image.image = [UIImage imageNamed:imageName[@"image"]];
        titleView.tag = i;
        [titleView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick:)]];
        [self.labelView addSubview:titleView];
    }
}


#pragma mark - scrollView代理方法

//滚动结束后调用
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSUInteger index = scrollView.contentOffset.x / self.contentView.width; //获得索引
    TitleView *titleView = (TitleView *)self.labelView.subviews[index];   //获得标签
    CGFloat offsetX = titleView.center.x - self.labelView.width * 0.5;
    CGFloat offsetMax = self.labelView.contentSize.width - self.labelView.width;
    if (offsetX < 0) {
        offsetX = 0;
    } else if (offsetX > offsetMax) {
        offsetX = offsetMax;
    }
    CGPoint offset = CGPointMake(offsetX, self.labelView.contentOffset.y);
    [self.labelView setContentOffset:offset animated:YES];
    //添加控制器
    NewsTableViewController *newsVC = self.childViewControllers[index];
    [self.labelView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx != index) {
            TitleView *tempTitle = self.labelView.subviews[idx];
            tempTitle.scale = 0.0;
        }
    }];
    if (newsVC.view.superview) return;
    newsVC.view.frame = scrollView.bounds;
    [self.contentView addSubview:newsVC.view];
}

//滑动结束后
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

//正在滚动中
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //取出绝对值 避免最左边往右拉时形变超过1
    CGFloat value = ABS(scrollView.contentOffset.x / scrollView.width);
    NSUInteger leftIndex = (int)value;
    NSUInteger rightIndex = leftIndex + 1;
    CGFloat scaleRight = value - leftIndex;
    CGFloat scaleLeft = 1 - scaleRight;
    TitleView *buttonLeft = self.labelView.subviews[leftIndex];
    buttonLeft.scale = scaleLeft;
    //最后一个Button不再为下一个赋值scale
    if (rightIndex < self.labelView.subviews.count) {
        TitleView *labelRight = self.labelView.subviews[rightIndex];
        labelRight.scale = scaleRight;
    }
}

#pragma mark - 事件响应方法

//标题栏的点击事件
- (void)labelClick:(UITapGestureRecognizer *)recognizer {
    TitleView *titleView = (TitleView *)recognizer.view;
    CGFloat offsetX = titleView.tag *self.contentView.width;
    CGFloat offsetY = self.contentView.contentOffset.y;
    CGPoint offset = CGPointMake(offsetX, offsetY);
    [self.contentView setContentOffset:offset animated:YES];
}

@end
