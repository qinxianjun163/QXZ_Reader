//
//  CircleLayout.m
//  QZXReaderReader
//
//  Created by 肖冯敏 on 15/9/9.
//  Copyright (c) 2015年 o‘clock. All rights reserved.
//

#import "CircleLayout.h"

@interface CircleLayout()

@property (nonatomic, assign) CGFloat cellCount;

@property (nonatomic, assign) CGFloat sectionNum;


@property (nonatomic, assign) CGPoint center;

@property (nonatomic, assign) CGFloat radius;

@end


@implementation CircleLayout


//如何在滑动, 是cell 滑动
- (void)prepareLayout {
    [super prepareLayout];//继承父类的准备工作
    
    CGSize size = self.collectionView.frame.size;
    _cellCount = [[self collectionView] numberOfItemsInSection:self.indexPathSection];
    _sectionNum = [[self collectionView] numberOfSections];
    _center = CGPointMake(size.width / 2.0, size.height/ 2.0);
    _radius = MIN(size.width, size.height)/2.5;
}

#warning <contentSize>
- (CGSize)collectionViewContentSize {
//    return [self collectionView].frame.size;
    return CGSizeMake([self collectionView].frame.size.width, [self.collectionView numberOfItemsInSection:self.indexPathSection] * kScreenHeight / 4);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    [super layoutAttributesForItemAtIndexPath:indexPath];
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    //配置attributes到圆周上
    //计算size
    CGFloat width = kScreenWidth / cos(M_PI / 12) + kScreenHeight / 4 * tan(M_PI / 12);
    CGFloat offsetHeight = kScreenHeight / 4 / 2 *cos(M_PI / 12);
    attributes.size = CGSizeMake(width, kScreenHeight / 4);
    //在这里切换为斜着的视角
    attributes.center = CGPointMake(_center.x, kScreenHeight / 4 * indexPath.item + offsetHeight * 3 / 10);
    attributes.transform = CGAffineTransformMakeRotation(M_PI / 12 * -1);
    return attributes;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attributes = [NSMutableArray array];
//    for (NSInteger j = 0; j <self.sectionNum; j++) {
        for (NSInteger i = 0 ; i < self.cellCount; i++) {
            //这里利用了-layoutAttributesForItemAtIndexPath:来获取attributes
            NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:self.indexPathSection];
            [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
        }
//    }
    return attributes;
}

//表示一旦滑动就调用这个
- (BOOL) shouldInvalidateLayoutForBoundsChange:(CGRect)newBound
{
    return YES;
}

//- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity;

// return a point at which to rest after scrolling - for layouts that want snap-to-point scrolling behavior
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset NS_AVAILABLE_IOS(7_0) {
    return CGPointMake(0, 100);
} // a layout can return the content offset to be applied during transition or update animations


@end
