//
//  MovieTypeViewCell.m
//  QZX_Reader
//
//  Created by zhangsiyao on 15/9/26.
//  Copyright © 2015年 ZhangSiYao. All rights reserved.
//

#import "MovieTypeViewCell.h"
#import "UIImageView+WebCache.h"

@interface MovieTypeViewCell ()

@property (strong, nonatomic) UIImageView *image;   //背景图片
@property (strong, nonatomic) UILabel *name;    //分类名
@property (strong, nonatomic) UIView *view;

@end

@implementation MovieTypeViewCell

//重写init方法布局
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //image
        self.image = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:self.image];
        
        self.view = [[UIView alloc] initWithFrame:self.image.frame];
        self.view.backgroundColor = [UIColor blackColor];
        self.view.alpha = 0.5;
        [self.contentView addSubview:self.view];
        
        //name
        self.name = [[UILabel alloc] initWithFrame:self.bounds];
        self.name.textAlignment = NSTextAlignmentCenter;
        self.name.textColor = [UIColor whiteColor];
        [self.contentView addSubview:self.name];
    }
    return self;
}

//重写model的set方法
- (void)setModel:(MovieTypeModel *)model
{
    _model = model;
    [self.image sd_setImageWithURL:[NSURL URLWithString:model.bgPicture] placeholderImage:[UIImage imageNamed:@"CategoryPlaceholder"]];
    
    self.name.text = model.name;
}

- (void)setHighlighted:(BOOL)highlighted
{
    if (highlighted == YES) {
        
        [UIView animateWithDuration:0.2 animations:^{
            _view.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
            _name.alpha = 0;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.8 animations:^{
            _view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
            _name.alpha = 1.0;
        }];
    }
}

@end
