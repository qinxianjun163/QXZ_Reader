//
//  ReadListPortaitCell.m
//  ReaderThreeTest
//
//  Created by 肖冯敏 on 15/9/17.
//  Copyright (c) 2015年 o‘clock. All rights reserved.
//

#import "ReadListPortaitCell.h"
#import "UIImageView+WebCache.h"
#import "LayoutMacro.h"
#import "UILabel+UpdataTime.h"
#import "UIView+Frame.h"

@interface ReadListPortaitCell()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *digestLabel;
@property (nonatomic, strong) UILabel *sourceLabel;
@property (nonatomic, strong) UIView *cellDetailView; //用于存放上面三个view 方便自适应

@property (nonatomic, strong) UIView *referenceView; //用于存放imageSrcView 方便自适应

@property (nonatomic, strong) UIImageView *imageSrcView;

@end

@implementation ReadListPortaitCell

static CGFloat cellHeight;
static CGFloat cellWidth;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat height = self.bounds.size.height;
        CGFloat width = self.bounds.size.width;
        cellHeight = height;
        cellWidth = width;
        
        self.imageSrcView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width / 4, height / 10 * 7)];

        self.referenceView = [[UIView alloc] initWithFrame:CGRectMake(width / 20 * 15, height / 20 * 3, width / 4, height / 10 * 7)];
        self.referenceView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.referenceView];
        [self.referenceView addSubview:self.imageSrcView];
        
        self.cellDetailView = [[UIView alloc] initWithFrame:CGRectMake(width / 20, 0, width / 4 * 3, height)];
        [self.contentView addSubview:self.cellDetailView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, height / 20 * 3, width / 3 * 2, height / 10 * 6)];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.numberOfLines = 0;
        [self.cellDetailView addSubview:self.titleLabel];
        
        self.sourceLabel = [UILabel new];
        [self addSubview:self.sourceLabel];
    }
    return self;
}

- (void)setModel:(ReadDetailModel *)model {
    //修正, sd_webImage 先创建一个小的UIView imageView放在UIView上, imageView 的大小适应图片的大小的小值,UIView clip center = center .
    _model = model;
    self.titleLabel.text = model.title;
    self.sourceLabel.text = model.source;
    [self.imageSrcView sd_setImageWithURL:[NSURL URLWithString:model.imgsrc] placeholderImage:[UIImage imageNamed:@"LongPlaceholder"]];

    //大小自适应 ---
    CGFloat imageViewHeight;
    CGFloat imageViewWidth;
    
    if (self.model.pixel) {
        NSArray *array = [self.model.pixel componentsSeparatedByString:@"*"];
        CGFloat imageWidth = [array[0] floatValue];
        CGFloat imageHeight = [array[1] floatValue];
        imageViewHeight = cellHeight / 10 * 9;
        
        imageViewWidth = imageViewHeight / imageHeight * imageWidth ;
        if ((imageWidth > imageViewWidth || imageViewHeight > imageViewHeight || imageWidth / imageHeight != imageViewWidth / imageViewHeight )) {
            if (imageWidth / imageHeight > imageViewWidth / imageViewHeight) {
                imageViewWidth = imageWidth / imageHeight *imageViewHeight;
            } else {
                imageViewHeight = imageHeight / imageWidth *imageViewWidth;
            }
        }
    } else {
        imageViewHeight = cellHeight / 10 * 9;
        imageViewWidth = cellWidth / 4 * 3;
    }
    if ([_model.imgsrc isEqualToString:@""]) {
        self.cellDetailView.frame = CGRectMake(cellWidth / 20 , 0, [UIScreen mainScreen].bounds.size.width * 9 / 10, cellHeight);
        self.titleLabel.frame = CGRectMake(0, cellHeight / 20 * 3, cellWidth / 10 * 9, cellHeight / 10 * 6);
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    } else {
        self.referenceView.frame = CGRectMake(cellWidth - imageViewWidth - cellWidth / 20, self.bounds.size.height / 20 * 3, imageViewWidth, self.bounds.size.height);
        self.imageSrcView.frame = CGRectMake(0, 0, imageViewWidth, cellHeight / 10 * 7);
        self.cellDetailView.frame = CGRectMake(cellWidth / 20, 0, cellWidth / 4 * 3, cellHeight);
        self.titleLabel.frame = CGRectMake(0, cellHeight / 20 * 3, kScreenWidth - kScreenWidth / 20 * 3 - imageViewWidth, cellHeight / 10 * 6);
        self.titleLabel.textAlignment = NSTextAlignmentLeft;

    }
    self.model.title = [self.model.title stringByReplacingOccurrencesOfString:@" " withString:@"\n"];
    self.titleLabel.text = model.title;
    [self.sourceLabel changeUpdataTimeFromDate:model.ptime];
    self.sourceLabel.font = [UIFont systemFontOfSize:10];
    self.sourceLabel.textColor = [UIColor grayColor];
    self.sourceLabel.textAlignment = NSTextAlignmentCenter;
    self.sourceLabel.frame = CGRectMake(0, self.height - 15, kScreenWidth, 10);
}



@end
