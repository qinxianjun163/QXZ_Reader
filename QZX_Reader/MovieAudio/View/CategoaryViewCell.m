//
//  CategoaryViewCell.m
//  QZX_Reader
//
//  Created by zhangsiyao on 15/9/26.
//  Copyright © 2015年 ZhangSiYao. All rights reserved.
//

#import "CategoaryViewCell.h"
#import "UIImageView+WebCache.h"
#import "UILabel+Categoary.h"
#import "LayoutMacro.h"

@interface CategoaryViewCell ()

@property (strong, nonatomic) UIImageView *image;
@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UILabel *detail;
@property (strong, nonatomic) UIView *bgView;

@end

@implementation CategoaryViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        NSInteger height = kScreenWidth / 1242 * 777;
        self.image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, height)];
        [self addSubview:self.image];
        
        self.bgView = [[UIView alloc] initWithFrame:self.image.frame];
        self.bgView.backgroundColor = [UIColor blackColor];
        self.bgView.alpha = 0.5;
        [self addSubview:self.bgView];
        
        CGFloat y = (height - 60) / 2;
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(0, y, kScreenWidth, 30)];
        self.title.textAlignment = NSTextAlignmentCenter;
        self.title.font = [UIFont systemFontOfSize:18];
        self.title.textColor = [UIColor whiteColor];
        [self addSubview:self.title];
        
        self.detail = [[UILabel alloc] initWithFrame:CGRectMake(0, y + 30, kScreenWidth, 30)];
        self.detail.textAlignment = NSTextAlignmentCenter;
        self.detail.font = [UIFont systemFontOfSize:14];
        self.detail.textColor = [UIColor whiteColor];
        [self addSubview:self.detail];
        
    }
    return self;
}

//根据model给cell赋值
- (void)setModel:(CategoaryModel *)model {
    _model = model;
    
    //给图片赋值
    [_image sd_setImageWithURL:[NSURL URLWithString:model.coverForDetail] placeholderImage:[UIImage imageNamed:@"CategoryPlaceholder"]];
    //给title赋值
    _title.text = model.title;
    //给Detail赋值
    [_detail detailWithStyle:model.category time:model.duration];
}


//重写cell的高亮状态使得点击文本消失,非高亮状态文本出现
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if (highlighted == YES) {
        [UIView animateWithDuration:0.2 animations:^{
            _bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
            _title.alpha = 0;
            _detail.alpha = 0;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.8 animations:^{
            _bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
            _title.alpha = 1.0;
            _detail.alpha = 1.0;
        }];
    }
}

@end
