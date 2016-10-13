//
//  DownloadViewController.m
//  QZX_Reader
//
//  Created by zhangsiyao on 15/10/4.
//  Copyright © 2015年 ZhangSiYao. All rights reserved.
//

#import "DownloadViewController.h"
#import "DetailViewController.h"
#import "DownloadCell.h"
#import "LayoutMacro.h"
#import "DB.h"
#import "ThemeColor.h"

@interface DownloadViewController ()

@property (strong, nonatomic) NSMutableArray *totalArray;   //总数组,存储正在下载和完成下载
@property (strong, nonatomic) NSMutableArray *downloadingArray; //正在下载的数组
@property (strong, nonatomic) NSMutableArray *downloadCompletedArray;   //下载完成的数组

@end

@implementation DownloadViewController

static NSString *downloadCell = @"DownloadCell";
static NSString *downloadHeader = @"DownloadHeader";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = YES;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    [self.tableView registerClass:[DownloadCell class] forCellReuseIdentifier:downloadCell];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:downloadHeader];
    
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;
    self.tableView.rowHeight = (int)(kScreenWidth / 1242 * 777);
    self.downloadingArray = (NSMutableArray *)[DB allDownloading];
    self.downloadCompletedArray = (NSMutableArray *)[DB allDownloadComplated];
    self.totalArray = [NSMutableArray arrayWithObjects:self.downloadingArray, self.downloadCompletedArray, nil];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(backClick)];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    self.navigationController.navigationBar.tintColor = kThemeColor;
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    titleView.text = @"缓存";
    titleView.font = [UIFont boldSystemFontOfSize:18];
    titleView.textColor = kThemeColor;
    self.navigationItem.titleView = titleView;
}

- (void)backClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.totalArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.totalArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DownloadCell *cell = [tableView dequeueReusableCellWithIdentifier:downloadCell forIndexPath:indexPath];
    cell.model = self.totalArray[indexPath.section][indexPath.row];
    cell.indexPath = indexPath;
    [cell downloadComplated:^(NSIndexPath *indePath) {
        CategoaryModel *model = self.downloadingArray[indexPath.row];
        [self.downloadCompletedArray insertObject:model atIndex:0];
        [self.downloadingArray removeObject:model];
        [self.tableView reloadData];
    } delete:^(NSIndexPath *indexPath) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认删除下载的视频" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *defineDelete = [UIAlertAction actionWithTitle:@"删除下载" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            if (indexPath.section == 0) {
                CategoaryModel *model = self.downloadingArray[indexPath.row];
                [DB deleteDownloading:model.playUrl];
                [self.downloadingArray removeObject:model];
            } else {
                CategoaryModel *model = self.downloadCompletedArray[indexPath.row];
                [DB deleteDownloadComplated:model.playUrl];
                [self.downloadCompletedArray removeObject:model];
            }
            [self.tableView reloadData];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:defineDelete];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:downloadHeader];
    if (section == 0) {
        headerView.textLabel.text = @"正在缓存到本地";
    } else {
        headerView.textLabel.text = @"已经缓存到本地";
    }
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    detailVC.model = self.totalArray[indexPath.section][indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end