//
//  NewsTableViewController.m
//  QZX_Reader
//
//  Created by zhangsiyao on 15/9/14.
//  Copyright (c) 2015年 ZhangSiYao. All rights reserved.
//

#import "NewsTableViewController.h"
#import "UIView+Frame.h"
#import "LayoutMacro.h"
#import "SYNetworkTools.h"
#import "SYNewsModel.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "SYNewsCell.h"
#import "SYDetailController.h"
#import "SYPhotoViewController.h"
#import "JDStatusBarNotification.h"
#import "SYCollected.h"

@interface NewsTableViewController ()
{
    CGFloat contentOffSetY;
}

@property (strong, nonatomic) NSMutableArray *arrayList;
@property (assign, nonatomic) BOOL update;

@end

@implementation NewsTableViewController


#pragma mark - 视图加载方法

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = YES;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.view.backgroundColor = [UIColor clearColor];
    
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.update = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.update == YES) {
        [self.tableView.header beginRefreshing];
        self.update = NO;
    }
    [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"contentStart" object:nil]];
}


#pragma mark - 懒加载方法

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)setUrlString:(NSString *)urlString {
    _urlString = urlString;
}


#pragma - mark 以供调用方法

- (void)loadDataForType:(int)type withURL:(NSString *)allUrlstring {
    [[[SYNetworkTools sharedNewworkTools] GET:allUrlstring parameters:nil success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        NSString *key = [responseObject.keyEnumerator nextObject];
        NSArray *tempArray = responseObject[key];
        NSMutableArray *arrayM = [SYNewsModel objectArrayWithKeyValuesArray:tempArray];
        if (type == 1) {
            self.arrayList = arrayM;
            [self.tableView.header endRefreshing];
            [self.tableView reloadData];
            [self refreshEndHint:type];
        } else if (type == 2) {
            [self.arrayList addObjectsFromArray:arrayM];
            [self.tableView.footer endRefreshing];
            [self.tableView reloadData];
            [self refreshEndHint:type];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [JDStatusBarNotification showWithStatus:@"✘刷新失败"
                                   dismissAfter:2.0
                                      styleName:JDStatusBarStyleWarning];
    }] resume];
}

- (void)refreshEndHint:(int)type {
    if (type == 1) {
        [JDStatusBarNotification showWithStatus:@"✔︎已经刷新"
                                   dismissAfter:2.0
                                      styleName:JDStatusBarStyleSuccess];
    } else if (type == 2) {
        [JDStatusBarNotification showWithStatus:@"✔︎已经刷新"
                                   dismissAfter:2.0
                                      styleName:JDStatusBarStyleSuccess];
    }
}

#pragma mark - 刷新数据方法

//下拉刷新
- (void)loadData {
    NSString *allURLString = [NSString stringWithFormat:@"/nc/article/%@/0-20.html", self.urlString];
    [self loadDataForType:1 withURL:allURLString];
}

//上拉加载
- (void)loadMoreData {
    NSString *allURLString = [NSString stringWithFormat:@"/nc/article/%@/%d-20.html", self.urlString, (int)(self.arrayList.count - self.arrayList.count % 10)];
    [self loadDataForType:2 withURL:allURLString];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.arrayList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SYNewsModel *newsModel = self.arrayList[indexPath.row];
    NSString *ID = [SYNewsCell idForRow:newsModel];
    if ((indexPath.row % 20 == 0) && (indexPath.row != 0)) {
        ID = @"NewsCell";
    }
    SYNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    cell.newsModel = newsModel;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}


#pragma mark - Table view Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SYNewsModel *newsModel = self.arrayList[indexPath.row];
    CGFloat rowHeight = [SYNewsCell heightForRow:newsModel];
    if ((indexPath.row % 20 == 0) && (indexPath.row != 0)) {
        rowHeight = 100;
    }
    return rowHeight;
}


#pragma mark - ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat translationInView = [self.tableView.panGestureRecognizer velocityInView:self.tableView].y;
    if (translationInView < 0) {
        [UIView animateWithDuration:0.4 animations:^{
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            [self.tabBarController.tabBar setHidden:YES];
            self.labelView.backgroundColor = [UIColor clearColor];
        }];
    } else if (translationInView > 1500 || scrollView.contentOffset.y == 0) {
        [UIView animateWithDuration:0.4 animations:^{
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            [self.tabBarController.tabBar setHidden:NO];
            self.labelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        }];
    }
}


#pragma mark - Storyboard跳转segue方法

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[SYDetailController class]]) {
        NSInteger row = self.tableView.indexPathForSelectedRow.row;
        SYDetailController *detailVC = segue.destinationViewController;
        detailVC.newsModel = self.arrayList[row];
        detailVC.index = self.index;
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
        SYNewsModel *model = self.arrayList[row];
        [SYCollected historyReadByFileName:@"NewsHistory" WithInfo:model.title];
    } else {
        NSInteger row = self.tableView.indexPathForSelectedRow.row;
        SYPhotoViewController *photoVC = segue.destinationViewController;
        photoVC.newsModel = self.arrayList[row];
        SYNewsModel *model = self.arrayList[row];
        [SYCollected historyReadByFileName:@"NewsHistory" WithInfo:model.title];
    }
}

@end
