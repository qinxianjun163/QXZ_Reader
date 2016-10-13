//
//  CategoaryViewController.m
//  QZX_Reader
//
//  Created by zhangsiyao on 15/9/26.
//  Copyright © 2015年 ZhangSiYao. All rights reserved.
//

#import "CategoaryViewController.h"
#import "LayoutMacro.h"
#import "MJRefresh.h"
#import "CategoaryModel.h"
#import "CategoaryViewCell.h"
#import "DetailViewController.h"

@interface CategoaryViewController () <NSURLConnectionDataDelegate>

@property (strong, nonatomic) NSMutableArray *array;

@end

@implementation CategoaryViewController

static NSString *reuserIdentifier = @"CategoaryCell";


#pragma mark - 视图加载方法

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = YES;
    self.tableView.separatorStyle = NO;
    //注册cell
    [self.tableView registerClass:[CategoaryViewCell class] forCellReuseIdentifier:reuserIdentifier];   //设置Row的高度.
    self.tableView.rowHeight = (int)(kScreenWidth / 1242 * 777);
    self.tableView.showsVerticalScrollIndicator = NO;   //隐藏垂直滑动条
    //请求加载数据
    [self requestData];
}


#pragma mark - 懒加载

- (NSMutableArray *)array{
    if (!_array) {
        self.array = [NSMutableArray array];
    }
    return _array;
}

#pragma mark - 调用方法

- (void)requestData {
    //动态获取当天时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //给他一个格式
    formatter.dateFormat = @"yyyyMMdd";
    formatter.timeZone = [NSTimeZone systemTimeZone];
    NSString *date = [formatter stringFromDate:[NSDate date]];
    NSString *urlStr = [NSString stringWithFormat:@"http://baobab.wandoujia.com/api/v1/videos?strategy=%@&categoryName=%@&num=10", date, self.model.category];
    if (self.isDetail) {
        urlStr = self.url;
    }
    //获取url
    NSURL *url = [NSURL URLWithString:urlStr];
    //网络请求需求
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //发送网络请求
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //数据解析
        //创建字典接受数据
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        self.nextPageUrl = dic[@"nextPageUrl"];
        //做一个判断
        if (self.isDetail) {
            //往期分类详情解析
            NSMutableArray *subArray = [NSMutableArray array];
            for (NSDictionary *videoList in dic[@"videoList"]) {
                CategoaryModel *model = [CategoaryModel new];
                [model setValuesForKeysWithDictionary:videoList];
                [subArray addObject:model];
            }
            [self.array addObject:subArray];
        }
        //刷新数据
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
    [task resume];
    //继承刷新控件
    [self performSelector:@selector(setupRefresh) withObject:nil];
}


#pragma mark - 事件响应方法

- (void)setupRefresh {
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        NSURLSession *session = [NSURLSession sharedSession];
        //网络请求
        NSString *urlStr = self.nextPageUrl;
        //获取url
        NSURL *url = [NSURL URLWithString:urlStr];
        //网络请求需求
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        //发送网络请求
        NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            self.nextPageUrl = dic[@"nextPageUrl"];
            //做一个判断
            if (self.isDetail) {
                //往期分类详情解析
                NSMutableArray *subArray = [NSMutableArray array];
                for (NSDictionary *videoList in dic[@"videoList"]) {
                    CategoaryModel *model = [[CategoaryModel alloc] init];
                    [model setValuesForKeysWithDictionary:videoList];
                    [subArray addObject:model];
                }
                [self.array addObject:subArray];
            }
            //刷新数据
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }];
        [task resume];
        [self.tableView.footer endRefreshing];
    }];
    self.tableView.footer.automaticallyRefresh = NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.array.count;
}

#pragma makr - 返回行数的方法 -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.array[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CategoaryViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserIdentifier forIndexPath:indexPath];
    //赋值
    CategoaryModel *model = self.array[indexPath.section][indexPath.row];
    cell.model = model;
    return cell;
}

#pragma mark - 点击row跳转的方法 -
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //开辟空间
    DetailViewController *detail = [DetailViewController new];
    detail.model = self.array[indexPath.section][indexPath.row];
    detail.isToday = YES;
    //设置详情界面的标题
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    titleView.text = @"视频详情";
    titleView.font = [UIFont boldSystemFontOfSize:18];
    titleView.textColor = [UIColor colorWithRed:189 / 255.0 green:161 / 255.0 blue:69 / 255.0 alpha:1.0];
    detail.navigationItem.titleView = titleView;
    //设置左边item
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 25, 25);
    [backBtn setImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    detail.navigationItem.leftBarButtonItem = leftItem;
    //跳转到detail页面
    [self.navigationController pushViewController:detail animated:YES];
}


- (void)back:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
