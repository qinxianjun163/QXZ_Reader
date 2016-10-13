//
//  ReadCollected.m
//  QZX_Reader
//
//  Created by zhangsiyao on 15/10/5.
//  Copyright © 2015年 ZhangSiYao. All rights reserved.
//

#import "ReadCollected.h"
#import "CollectionReader.h"
#import "CollectionModel.h"
#import "MyWebView.h"
#import "ReadWebViewController.h"
#import "ThemeColor.h"

@interface ReadCollected ()

@property (strong, nonatomic) NSManagedObjectContext *context;

@end

@implementation ReadCollected

static NSString *reuserIdentifier = @"ReadCollectedCell";
static NSString *header = @"ReadCollectedHeader";

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
        self.dataArray = [NSArray array];
    }
    return _dataArray;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [CollectionReader creatCollectionWithContext:self.context];
    self.dataArray = [CollectionReader selectAllCollectionWithContext:self.context];
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
    CollectionModel *model = self.dataArray[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", model.title];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:header];
    headerView.textLabel.text = [NSString stringWithFormat:@"阅读收藏（%d条）", (int)self.dataArray.count];
    headerView.contentView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.tabBarController.tabBar.hidden = YES;
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
