//
//  ReadRusableView.h
//  QZXReaderReader
//
//  Created by 肖冯敏 on 15/9/10.
//  Copyright (c) 2015年 o‘clock. All rights reserved.
//


//ReadRuseableView 显示在 阅读 第一个页面的cell
#import <UIKit/UIKit.h>
#import "ReadListModel.h"

@interface ReadRusableView : UICollectionViewCell

@property (nonatomic, strong) ReadListModel *model; //模型, 用来存储 数据
@property (nonatomic, strong) UIImageView *imageSrcView; //显示图片
@property (nonatomic, strong) UILabel *titleLabel;  //显示标题

@end
