//
//  ReadSideCell.h
//  QZX_Reader
//
//  Created by 肖冯敏 on 15/10/9.
//  Copyright © 2015年 ZhangSiYao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReadListModel.h"

@interface ReadSideCell : UICollectionViewCell

@property (nonatomic, strong) ReadListModel *model; //模型, 用来存储 数据
@property (nonatomic, strong) UIImageView *imageSrcView; //显示图片
@property (nonatomic, strong) UILabel *titleLabel;  //显示标题

@end
