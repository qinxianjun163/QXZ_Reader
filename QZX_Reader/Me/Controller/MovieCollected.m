//
//  MovieCollected.m
//  QZX_Reader
//
//  Created by zhangsiyao on 15/10/4.
//  Copyright © 2015年 ZhangSiYao. All rights reserved.
//

#import "MovieCollected.h"
#import "DB.h"
#import "CategoaryModel.h"
#import "DetailViewController.h"

@interface MovieCollected ()

@end

@implementation MovieCollected

static NSString *reuserIdentifier = @"MovieCollectedCell";
static NSString *header = @"MovieCollectedHeader";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = NO;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuserIdentifier];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:header];
    self.view.backgroundColor = [UIColor clearColor];
}

- (NSArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.dataArray = [DB allMovieCollection];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed:189 / 255.0 green:161 / 255.0 blue:69 / 255.0 alpha:1.0];
    CategoaryModel *model = self.dataArray[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@（%@）", model.title, model.category];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:header];
    headerView.textLabel.text = [NSString stringWithFormat:@"视频收藏（%d条）", (int)self.dataArray.count];
    headerView.contentView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //开辟空间
    DetailViewController *detail = [DetailViewController new];
    detail.model = self.dataArray[indexPath.row];
    detail.isToday = YES;
    detail.navigationItem.title = @"视频详情";
    [self.navigationController pushViewController:detail animated:YES];
    self.tabBarController.tabBar.hidden = YES;
}

@end
