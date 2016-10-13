//
//  SYReplyViewController.m
//  QZX_Reader
//
//  Created by zhangsiyao on 15/9/16.
//  Copyright (c) 2015年 ZhangSiYao. All rights reserved.
//

#import "SYReplyViewController.h"
#import "SYReplyHeader.h"
#import "SYReplyCell.h"
#import "LayoutMacro.h"
#import "UIImage+SYArchver.h"

@interface SYReplyViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIImageView *bgImageView;

@end

@implementation SYReplyViewController

static NSString *reuserIdentifier = @"ReplyCell";


#pragma mark - 视图加载方法

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgImage"]];
    self.bgImageView.image = [UIImage getImageWithSavePhotoName:@"bgPhoto.jpg"];
    self.bgImageView.frame = self.view.bounds;
    [self.view addSubview:self.bgImageView];
    [self.view sendSubviewToBack:self.bgImageView];
    UIVisualEffectView *visualEfView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    visualEfView.frame = [UIScreen mainScreen].bounds;
    [self.bgImageView addSubview:visualEfView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.bgImageView.image = [UIImage getImageWithSavePhotoName:@"bgPhoto.jpg"];
}

- (IBAction)dismissController:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (self.replyArray.count == 0) {
        return 1;
    }
    if (section == 0) {
        return self.replyArray.count;
    } else {
        return self.replyArray.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SYReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserIdentifier];
    
    if (cell == nil) {
        cell = [[SYReplyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuserIdentifier];
    }
    
    if (self.replyArray.count == 0) {
        UITableViewCell *cell2 = [[UITableViewCell alloc]init];
        cell2.textLabel.text = @"     暂无跟帖数据";
        return cell2;
    } else {
        SYReplyModel *model = self.replyArray[indexPath.row];
        cell.replyModel = model;
    }
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return [SYReplyHeader replyViewFirst];
    } else {
        return [SYReplyHeader replyViewLast];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.replyArray.count == 0) {
        return 40;
    } else {
        SYReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserIdentifier];
        
        SYReplyModel *model = self.replyArray[indexPath.row];
        
        cell.replyModel = model;
        
        [cell layoutIfNeeded];
        
        CGSize size = [cell.sayLabel systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        
        return cell.sayLabel.frame.origin.y + size.height + 10;
    }
}

/** 预估行高，这个方法可以减少上面方法的调用次数，提高性能 */
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130;
}

@end
