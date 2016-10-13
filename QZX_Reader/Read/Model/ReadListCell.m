//
//  ReadListCell.m
//  ReaderThreeTest
//
//  Created by 肖冯敏 on 15/9/16.
//  Copyright (c) 2015年 o‘clock. All rights reserved.
//

#import "ReadListCell.h"
#import "UIImageView+WebCache.h"
#import "LayoutMacro.h"
#import "UILabel+UpdataTime.h"
#import "UIView+Frame.h"

@interface ReadListCell()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *digestLabel;
@property (nonatomic, strong) UILabel *sourceLabel;
@property (nonatomic, strong) UIView *cellDetailView;  //用于存放上面三个view 方便自适应

@property (nonatomic, strong) UIView *referenceView; //用于存放 要imageSrcView 方便自适应布局

@property (nonatomic, strong) UIImageView *imageSrcView;

@end

@implementation ReadListCell

static CGFloat cellHeight;
static CGFloat cellWidth;

static CGFloat referenceViewWidth;
static CGFloat cellDetailViewWidth;



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {        
        CGFloat height = self.bounds.size.height;
        CGFloat width = self.bounds.size.width;
        cellHeight = height;
        cellWidth = width;
        
        self.imageSrcView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width / 10 * 3, height / 10 * 7)];
        self.referenceView = [[UIView alloc] initWithFrame:CGRectMake(width / 20, height / 20 * 3, width / 10 * 3, height / 10 * 7)];
        self.referenceView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.referenceView];
        [self.referenceView addSubview:self.imageSrcView];

        self.cellDetailView = [[UIView alloc] initWithFrame:CGRectMake(width / 20 * 7, 0, width / 20 * 12, height)];
        [self.contentView addSubview:self.cellDetailView];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, height / 20 * 3, width / 20 * 12, height / 10 * 6)];
        self.titleLabel.numberOfLines = 0;
        [self.cellDetailView addSubview:self.titleLabel];
        
        self.sourceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, height / 10 * 7 , width / 20 * 12, height / 9)];
        [self addSubview:self.sourceLabel];
    }
    return self;
}

- (void)setModel:(ReadDetailModel *)model {
    //修正, sd_webImage 先创建一个小的UIView imageView放在UIView上, imageView 的大小适应图片的大小的小值,UIView clip center = center .
    _model = model;
    //大小自适应 ---
    
    CGFloat imageViewHeight;
    CGFloat imageViewWidth = 0.0;
    
    if (self.model.pixel) {
        NSArray *array = [self.model.pixel componentsSeparatedByString:@"*"];
        CGFloat imageWidth = [array[0] floatValue];
        CGFloat imageHeight = [array[1] floatValue];
        imageViewHeight = cellHeight / 10 * 7;
        imageViewWidth = imageViewHeight / imageHeight * imageWidth ;
        
        referenceViewWidth = imageViewWidth + cellWidth / 20;
        cellDetailViewWidth = cellWidth - referenceViewWidth;

    }
    if ([_model.imgsrc isEqualToString:@""]) {
        //如果没有图片的话
        self.cellDetailView.frame = CGRectMake(cellWidth / 20 , 0, [UIScreen mainScreen].bounds.size.width * 9 / 10, cellHeight);
        self.titleLabel.frame = CGRectMake(0, cellHeight / 20 * 3, cellWidth / 10 * 9, cellHeight / 10 * 6);
        self.sourceLabel.frame = CGRectMake(0, cellHeight / 10 * 7, cellWidth / 10 * 9, cellHeight / 9);
        self.sourceLabel.textAlignment = NSTextAlignmentCenter;
    } else {
        self.cellDetailView.frame = CGRectMake(self.imageSrcView.frame.size.width + cellWidth / 20, 0, cellDetailViewWidth, cellHeight);
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.frame = CGRectMake(cellDetailViewWidth / 20, cellHeight / 20 * 3, kScreenWidth - (cellWidth / 10 * 3) - kScreenWidth / 10, cellHeight / 10 * 6);
        self.sourceLabel.frame = CGRectMake(cellDetailViewWidth / 20, cellHeight / 20 * 15 , kScreenWidth - imageViewWidth - kScreenWidth / 20, cellHeight / 9);
        self.sourceLabel.textAlignment = NSTextAlignmentLeft;
        [self.imageSrcView sd_setImageWithURL:[NSURL URLWithString:model.imgsrc] placeholderImage:[UIImage imageNamed:@"302"]];
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
