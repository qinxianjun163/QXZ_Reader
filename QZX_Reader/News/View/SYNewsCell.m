//
//  SYNewsCell.m
//  QZX_Reader
//
//  Created by zhangsiyao on 15/9/15.
//  Copyright (c) 2015年 ZhangSiYao. All rights reserved.
//

#import "SYNewsCell.h"
#import "UIImageView+WebCache.h"
#import "UILabel+UpdataTime.h"

@interface SYNewsCell ()

/**
 *  发布时间
 */
@property (strong, nonatomic) IBOutlet UILabel *ptime;
/**
 *  图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
/**
 *  标题
 */
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
/**
 *  回复数
 */
@property (weak, nonatomic) IBOutlet UILabel *lblReply;
/**
 *  描述
 */
@property (weak, nonatomic) IBOutlet UILabel *lblSubtitle;
/**
 *  第二张图片（如果有的话）
 */
@property (weak, nonatomic) IBOutlet UIImageView *imgOther1;
/**
 *  第三张图片（如果有的话）
 */
@property (weak, nonatomic) IBOutlet UIImageView *imgOther2;
/**
 *  新闻来源
 */
@property (strong, nonatomic) IBOutlet UILabel *sourceTitle;

@end

@implementation SYNewsCell

- (void)setNewsModel:(SYNewsModel *)newsModel {
    _newsModel = newsModel;
    [self.imgIcon sd_setImageWithURL:[NSURL URLWithString:self.newsModel.imgsrc] placeholderImage:[UIImage imageNamed:@"302"]];
    self.lblTitle.text = self.newsModel.title;
    self.lblTitle.textColor = [UIColor colorWithRed:189 / 255.0 green:161 / 255.0 blue:69 / 255.0 alpha:1.0];
    self.lblSubtitle.text = self.newsModel.digest;
    self.lblSubtitle.textColor = [UIColor darkGrayColor];
    //回复超过1万则标万
    CGFloat count =  [self.newsModel.replyCount intValue];
    NSString *displayCount;
    if (count > 10000) {
        displayCount = [NSString stringWithFormat:@"%.1f万跟帖",count/10000];
    }else{
        displayCount = [NSString stringWithFormat:@"%.0f跟帖",count];
    }
    self.lblReply.text = displayCount;
    self.lblReply.textColor = [UIColor lightGrayColor];
    // 多图cell
    if (self.newsModel.imgextra.count == 2) {
        [self.imgOther1 sd_setImageWithURL:[NSURL URLWithString:self.newsModel.imgextra[0][@"imgsrc"]] placeholderImage:[UIImage imageNamed:@"302"]];
        [self.imgOther2 sd_setImageWithURL:[NSURL URLWithString:self.newsModel.imgextra[1][@"imgsrc"]] placeholderImage:[UIImage imageNamed:@"302"]];
    }
    //来源
    self.sourceTitle.text = self.newsModel.source;
    self.sourceTitle.textColor = [UIColor lightGrayColor];
    //时间
    [self.ptime changeUpdataTimeFromDate:newsModel.ptime];
}

//类方法返回可重用ID
+ (NSString *)idForRow:(SYNewsModel *)newsModel
{
    if (newsModel.hasHead && newsModel.photosetID) {
        return @"TopImageCell";
    }else if (newsModel.hasHead){
        return @"TopTxtCell";
    }else if (newsModel.imgType){
        return @"BigImageCell";
    }else if (newsModel.imgextra){
        return @"ImagesCell";
    }else{
        return @"NewsCell";
    }
}

//类方法返回行高
+ (CGFloat)heightForRow:(SYNewsModel *)newsModel
{
    if (newsModel.hasHead && newsModel.photosetID){
        return 265;
    }else if(newsModel.hasHead) {
        return 245;
    }else if(newsModel.imgType) {
        return 130;
    }else if (newsModel.imgextra){
        return 150;
    }else{
        return 100;
    }
}

@end
