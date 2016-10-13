//
//  ReadSideCollectionViewController.h
//  ReaderThreeTest
//
//  Created by 肖冯敏 on 15/9/25.
//  Copyright (c) 2015年 o‘clock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RACollectionViewReorderableTripletLayout.h"


@interface ReadSideCollectionViewController : UICollectionViewController 

@property (nonatomic, strong) NSMutableArray *dataArray;

//这里用来判断 数据的读取方式, 如果是的话, 数据从数据库中读取.....
@property (nonatomic, assign) BOOL willShowSub;

@end
