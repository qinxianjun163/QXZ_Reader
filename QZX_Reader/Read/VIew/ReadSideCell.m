//
//  ReadSideCell.m
//  QZX_Reader
//
//  Created by 肖冯敏 on 15/10/9.
//  Copyright © 2015年 ZhangSiYao. All rights reserved.
//

#import "ReadSideCell.h"
#import "LayoutMacro.h"
#import "UIImageView+WebCache.h"
#import "UIImage+WebP.h"
#import "UIView+Frame.h"
#import "LayoutMacro.h"
#import "ThemeColor.h"

@interface ReadSideCell()<NSURLSessionDownloadDelegate>

@property (strong, nonatomic) NSURLSessionDownloadTask *task;
@property (strong, nonatomic) NSURLSession *session;

@property (nonatomic, strong) UILabel *typeLabel;   //显示类别 (暂时没用上)
@property (nonatomic, strong) UILabel *sourceLabel; //显示简介
@property (nonatomic, strong) UIView *blackView;

@property (nonatomic, strong) UIVisualEffectView *visualEfView;

@end

@implementation ReadSideCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        if (self.width != kScreenWidth) {
            self.visualEfView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
            self.visualEfView.frame = CGRectMake(0, 0, self.width * 2, self.height * 2);
            [self.contentView addSubview:self.visualEfView];
        }
        self.clipsToBounds = YES;
        
        self.imageSrcView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width / 4, self.height /4, self.width/ 2, self.height/ 2)];
        [self.contentView addSubview:self.imageSrcView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.height / 4 * 3 + 10, self.width, 20)];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.textColor = kThemeColor;
        self.titleLabel.font = [self.titleLabel.font fontWithSize:self.height/5];
        
        self.blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        self.blackView.backgroundColor = [UIColor blackColor];
        self.blackView.alpha = 0.5;
        [self.contentView addSubview:self.blackView];
        
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

- (void)setModel:(ReadListModel *)model {
    _model = model;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://s.cimg.163.com/pi/img3.cache.netease.com/m/newsapp/topic_icons/%@.png.100x100.75.auto.webp", model.tid]];
    NSURLSessionConfiguration *cfg = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.session = [NSURLSession sessionWithConfiguration:cfg delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    self.task = [self.session downloadTaskWithURL:url];
    [self.task resume];
    self.titleLabel.text = model.tname;
    self.sourceLabel.text = model.alias;
    
    self.imageSrcView.frame = CGRectMake(self.frame.size.width / 4, self.frame.size.height /4, self.frame.size.width/ 2, self.frame.size.height/ 2);
    self.titleLabel.frame = CGRectMake(0, self.height / 12 * 10, self.width, 20);
    self.blackView.frame = CGRectMake(0, 0, self.width, self.height);
    self.titleLabel.font = [self.titleLabel.font fontWithSize:self.height/10];

}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location{
    NSString *cache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [cache stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.webp", self.model.tname]];
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:filePath]) {
        [fm moveItemAtPath:location.path toPath:filePath error:nil];
    }
    self.imageSrcView.image = [UIImage imageWithWebP:filePath];
    self.backgroundColor = [UIColor colorWithPatternImage:self.imageSrcView.image];
    self.visualEfView.frame = CGRectMake(0, 0, self.width, self.height);
}

//重写cell的高亮状态使得点击文本消失,非高亮状态文本出现
- (void)setHighlighted:(BOOL)highlighted {
    if (highlighted == YES) {
        [UIView animateWithDuration:0.2 animations:^{
            self.blackView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.0];
        }];
    }
    else
    {
        [UIView animateWithDuration:0.8 animations:^{
            self.blackView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        }];
    }
}

@end
