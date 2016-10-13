//
//  ReadListLongCell.m
//  ReaderThreeTest
//
//  Created by 肖冯敏 on 15/9/17.
//  Copyright (c) 2015年 o‘clock. All rights reserved.
//

#import "ReadListLongCell.h"
#import "UIImageView+WebCache.h"
#import "LayoutMacro.h"
#import "UILabel+UpdataTime.h"
#import "UIView+Frame.h"

@interface ReadListLongCell()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *digestLabel;
@property (nonatomic, strong) UILabel *sourceLabel; //显示发布时间
@property (nonatomic, strong) UIView *cellDetailView; //用于存放上面三个view 方便自适应
@property (nonatomic, strong) UIView *referenceView; //用于存放imageSrcView 方便自适应
@property (nonatomic, strong) UIImageView *imageSrcView; 

@end

@implementation ReadListLongCell

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
        
        self.clipsToBounds = YES;
        
        self.imageSrcView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        self.maskView = [[UIView alloc] initWithFrame:self.imageSrcView.frame];
        self.maskView.backgroundColor = [UIColor blackColor];
        self.maskView.alpha = 0.5;
        

        self.referenceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        self.referenceView.backgroundColor = [UIColor clearColor];
        
        self.cellDetailView = [[UIView alloc] initWithFrame:CGRectMake(width / 20 * 6, 0, width / 4 * 3, height)];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, height / 20 * 3, width / 3 * 2, height / 10 * 6)];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.numberOfLines = 0;
        
        self.sourceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.height - 15, kScreenWidth, 10)];
        self.sourceLabel.font = [UIFont systemFontOfSize:10];
        self.sourceLabel.textAlignment = NSTextAlignmentCenter;
        self.sourceLabel.textColor = [UIColor grayColor];
        
        [self.imageSrcView addSubview:self.maskView];
        [self.contentView addSubview:self.referenceView];
        [self.referenceView addSubview:self.imageSrcView];
        [self.contentView addSubview:self.cellDetailView];
        [self.cellDetailView addSubview:self.titleLabel];
        [self.maskView addSubview:self.sourceLabel];
    }
    return self;
}

- (void)setModel:(ReadDetailModel *)model {
    _model = model;
    CGFloat imageViewWidth = kScreenWidth;
    CGFloat imageViewHeight = kScreenHeight / 4;
    
    if (self.model.pixel) {
        NSArray *array = [self.model.pixel componentsSeparatedByString:@"*"];
        CGFloat imageWidth = [array[0] floatValue];
        CGFloat imageHeight = [array[1] floatValue];
        imageViewWidth = kScreenWidth;
        imageViewHeight = imageViewWidth / imageWidth * imageHeight;
    }
    if ([_model.imgsrc isEqualToString:@""]) {
        self.cellDetailView.frame = CGRectMake(cellWidth / 20 , 0, [UIScreen mainScreen].bounds.size.width * 9 / 10, cellHeight);
        self.titleLabel.frame = CGRectMake(0, cellHeight / 20 * 3, cellWidth / 10 * 9, cellHeight / 10 * 6);
    }
    else {
        self.cellDetailView.frame = CGRectMake(cellWidth / 20, 0, cellWidth / 20 * 18, cellHeight);
        self.titleLabel.frame = CGRectMake(0, cellHeight / 20 * 3, cellWidth / 20 * 18, cellHeight / 10 * 6);
        self.imageSrcView.frame = CGRectMake(0, 0, imageViewWidth, imageViewHeight);
        [self.imageSrcView sd_setImageWithURL:[NSURL URLWithString:model.imgsrc] placeholderImage:[UIImage imageNamed:@"LongPlaceholder"]];
    }
    self.model.title = [self.model.title stringByReplacingOccurrencesOfString:@" " withString:@"\n"];
    self.titleLabel.text = model.title;
    [self.sourceLabel changeUpdataTimeFromDate:self.model.ptime];
}

@end
