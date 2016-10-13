//
//  MovieController.m
//  QZX_Reader
//
//  Created by zhangsiyao on 15/9/14.
//  Copyright (c) 2015年 ZhangSiYao. All rights reserved.
//

#import "MovieController.h"
#import "LayoutMacro.h"
#import "MovieTypeModel.h"
#import "MovieTypeViewCell.h"
#import "CategoaryViewController.h"
#import "UIImage+SYArchver.h"

@interface MovieController () <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (strong, nonatomic) UIImageView *bgImageView;

@property (strong, nonatomic) NSMutableArray *array;

@end

@implementation MovieController

static NSString *reuseIdentifier = @"Cell";


#pragma mark - 视图加载方法

- (void)loadView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat width = (kScreenWidth - 2) / 2;
    layout.itemSize = CGSizeMake(width, width);
    layout.minimumLineSpacing = 2;
    layout.minimumInteritemSpacing = 0;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView = collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    titleView.text = @"Novelty";
    titleView.font = [UIFont fontWithName:@"SnellRoundhand-Black" size:20];
    titleView.textColor = [UIColor colorWithRed:189 / 255.0 green:161 / 255.0 blue:69 / 255.0 alpha:1.0];
    self.navigationItem.titleView = titleView;
    self.view.backgroundColor = [UIColor whiteColor];
    //注册cell
    [self.collectionView registerClass:[MovieTypeViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    //请求数据
    [self requestDate];
}


#pragma mark - 调用方法

- (void)requestDate {
    //网络请求数据和数据解析
    NSURLSession *session = [NSURLSession sharedSession];
    //创建url
    NSURL *url = [NSURL URLWithString:@"http://baobab.wandoujia.com/api/v1/categories"];
    //根据url创建请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //网络解析
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        //一般在forin前面初始化我们的数组,因为我们这里也不会上拉加载更多,所以用不到懒加载
        self.array = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            MovieTypeModel *model = [[MovieTypeModel alloc] initWithDictionary:dic];
            [self.array addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    }];
    [task resume];
}


#pragma mark - 事件响应方法

- (void)back:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UICollection Delegate DataScore

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.array count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MovieTypeViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    //赋值
    cell.model = self.array[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MovieTypeModel *model = self.array[indexPath.item];
    CategoaryViewController *categoaryVC = [CategoaryViewController new];
    //跳转到详情界面
    categoaryVC.isDetail = YES;
    categoaryVC.model.category = model.name;
    //设置详情界面的标题
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    titleView.text = [NSString stringWithFormat:@"%@", model.name];
    titleView.font = [UIFont boldSystemFontOfSize:18];
    titleView.textColor = [UIColor colorWithRed:189 / 255.0 green:161 / 255.0 blue:69 / 255.0 alpha:1.0];
    categoaryVC.navigationItem.titleView = titleView;
    //设置左边item
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 25, 25);
    [backBtn setImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    categoaryVC.navigationItem.leftBarButtonItem = leftItem;
    //拼接往期分类详情所用的url
    /*
     把一个NSString字符串 转换成c语言字符串
     主要用途：写数据库的时候，sql语句是用NSString类型写的时候，要做一个转换
     [model.name UTF8String];
     */
    categoaryVC.hidesBottomBarWhenPushed = YES;
    categoaryVC.url = [NSString stringWithFormat:@"http://baobab.wandoujia.com/api/v1/videos?num=10&categoryName=%@", [model.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    //push方法跳转
    [self.navigationController pushViewController:categoaryVC animated:YES];
}

@end