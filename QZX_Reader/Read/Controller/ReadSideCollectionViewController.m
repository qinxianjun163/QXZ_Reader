//
//  ReadSideCollectionViewController.m
//  ReaderThreeTest
//
//  Created by 肖冯敏 on 15/9/25.
//  Copyright (c) 2015年 o‘clock. All rights reserved.
//

#import "ReadSideCollectionViewController.h"
#import "ReadRusableView.h"
#import "ReadCatagoryViewController.h"
#import "LayoutMacro.h"
#import "ReadSideCell.h"

@interface ReadSideCollectionViewController ()

@property (nonatomic, strong) UIView *menuView;

@end

@implementation ReadSideCollectionViewController

static NSString * const reuseIdentifier = @"ReadSideCell";

- (void)loadView {
    RACollectionViewReorderableTripletLayout *layout = [RACollectionViewReorderableTripletLayout new];
    layout.itemSize = CGSizeMake(kScreenWidth / 2, kScreenWidth / 2);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
    self.collectionView = collectionView;
    self.collectionView.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerClass:[ReadSideCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight + 50);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
}

//切换layout
- (void)turnBackXLPlainFlowLayout {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ReadCatagoryViewController *readCatagoryVC = [[ReadCatagoryViewController alloc] init];
    int index = (int)indexPath.row;
    if ([[self.dataArray[0] class] isSubclassOfClass:[NSDictionary class]]) {
        readCatagoryVC.model = [[ReadListModel alloc] initWithDictionary:[self.dataArray objectAtIndex:index]];
    }
    else {
        readCatagoryVC.model = self.dataArray[index];
    }
    readCatagoryVC.superIndexPath = indexPath;
    readCatagoryVC.FromSub = self.willShowSub;
    [self.navigationController pushViewController:readCatagoryVC animated:YES];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ReadRusableView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if ([[self.dataArray[0] class] isSubclassOfClass:[NSDictionary class]]) {
       cell.model = [[ReadListModel alloc] initWithDictionary:self.dataArray[indexPath.row]];
    } else {
        cell.model = self.dataArray[indexPath.row];
    }
    return cell;
}


#pragma mark - 拖拽执行的方法

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

//- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    //这里还需要做的一件事是将colletionView中的数据改变一下
//    [self.collectionView reloadData];
//}
//
//- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath didMoveToIndexPath:(NSIndexPath *)toIndexPath
//{
//    if (fromIndexPath != toIndexPath) {
//        NSDictionary *tempDic = _dataArray[fromIndexPath.item];
//        
//        NSMutableArray *array = [NSMutableArray array];
//        for (NSDictionary *dic in _dataArray) {
//            [array addObject:dic];
//        }
//        
//        [array removeObjectAtIndex:fromIndexPath.item];
//        [array insertObject:tempDic atIndex:toIndexPath.item];
//        
//        _dataArray = array;
//    }
//}

@end
