//
//  DetailView.m
//  QZX_Reader
//
//  Created by zhangsiyao on 15/10/3.
//  Copyright © 2015年 ZhangSiYao. All rights reserved.
//

#import "DetailView.h"
#import "LayoutMacro.h"
#import "UIImageView+WebCache.h"
#import "UIView+Frame.h"
#import "UILabel+Categoary.h"
#import "BGImageView.h"
#import "DB.h"
#import "TotalDownloader.h"

@interface DetailView ()

@property (strong, nonatomic) BGImageView *bgImage;    //背景图片
@property (strong, nonatomic) UIImageView *backgroundImageView; //背景图
@property (strong, nonatomic) UILabel *titleLabel;  //标题
@property (strong, nonatomic) UILabel *categoryLabel;   //分类
@property (strong, nonatomic) UILabel *infoLabel;   //简介
@property (strong, nonatomic) DIYButton *collectionBtn;  //收藏按钮
@property (strong, nonatomic) DIYButton *shareBtn;   //分享按钮
@property (strong, nonatomic) DIYButton *cacheBtn;   //缓存按钮
@property (strong, nonatomic) UIImageView *templmageView;   //转换视图方向
@end

@implementation DetailView

- (void)dealloc {
    [_bgImage.timer invalidate];
    _delegate = nil;    //代理置为nil，防止异常
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        CGFloat height = frame.size.height * 0.5;
        CGFloat width = height / 777 * 1242;
        CGFloat x = -(width - frame.size.width) / 2;
        //详情背景图片反转视图
        self.templmageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, height + 64, kScreenWidth, kScreenHeight / 2 - 64)];
        _templmageView.transform = CGAffineTransformMake(_templmageView.transform.a, _templmageView.transform.b, _templmageView.transform.c, -1 *_templmageView.transform.d, _templmageView.transform.tx, _templmageView.transform.ty);
        [self addSubview:_templmageView];
        //视频图片的ImageView
        self.bgImage = [[BGImageView alloc] initWithFrame:CGRectMake(x, 0, width, height + 64)];
        //因为scrollView放大后可以拖动，所以关闭用户操作
        self.bgImage.userInteractionEnabled = NO;
        [self addSubview:_bgImage];
        //添加一个轻拍手势
        UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height + 64)];
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startPlay)];
        [tapView addGestureRecognizer:tapGR];
        [self addSubview:tapView];
        //创建play imageView
        CGFloat playX = (frame.size.width - 60) / 2;
        CGFloat playY = (height - 60) / 2 + 20;
        UIImageView *playImageView = [[UIImageView alloc] initWithFrame:CGRectMake(playX, playY, 60, 60)];
        playImageView.image = [UIImage imageNamed:@"play1"];
        [self addSubview:playImageView];
        //详情背景视图
        self.backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, height + 64, kScreenWidth, kScreenHeight / 2 - 64)];
        _backgroundImageView.userInteractionEnabled = YES;
        [self addSubview:_backgroundImageView];
        CGFloat bgHeight = self.backgroundImageView.height / 250;
        //标题
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, bgHeight * 10, kScreenWidth - 20, bgHeight * 30)];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [_backgroundImageView addSubview:_titleLabel];
        
        CGFloat categoryHeight = self.titleLabel.y + bgHeight * 45;
        //分类
        self.categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, categoryHeight, kScreenWidth - 20, bgHeight * 20)];
        _categoryLabel.alpha = 0.8;
        _categoryLabel.textColor = [UIColor whiteColor];
        _categoryLabel.font = [UIFont systemFontOfSize:15];
        [_backgroundImageView addSubview:_categoryLabel];
        CGFloat infoHeight = self.categoryLabel.y + bgHeight * 30;
        //详情
        self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, infoHeight, kScreenWidth - 20, bgHeight * 80)];
        _infoLabel.textColor = [UIColor whiteColor];
        _infoLabel.alpha = 0.7;
        _infoLabel.numberOfLines = 0;
        _infoLabel.font = [UIFont systemFontOfSize:13];
        [_backgroundImageView addSubview:_infoLabel];
        CGFloat otherBtnHeight = self.infoLabel.y + bgHeight * 110;
        CGFloat otherBtnWidth = (self.width  - 20) / 3.0;
        //收藏
        self.collectionBtn = [DIYButton buttonWithType:UIButtonTypeCustom];
        _collectionBtn.frame = CGRectMake(10, otherBtnHeight, otherBtnWidth, 20);
        _collectionBtn.icon.image = [UIImage imageNamed:@"unCollected_W"];
        _collectionBtn.iconSelected.image = [UIImage imageNamed:@"didCollected_W"];
        _collectionBtn.textLabel.text = @"  收藏";
        [_collectionBtn addTarget:self action:@selector(collection_:) forControlEvents:UIControlEventTouchUpInside];
        [_backgroundImageView addSubview:self.collectionBtn];
        
        //分享
        self.shareBtn = [DIYButton buttonWithType:UIButtonTypeCustom];
        _shareBtn.frame = CGRectMake(otherBtnWidth + 10, otherBtnHeight, otherBtnWidth, 20);
        _shareBtn.icon.image = [UIImage imageNamed:@"share"];
        _shareBtn.textLabel.text = @"   分享";
        [_shareBtn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
        [_backgroundImageView addSubview:_shareBtn];
        
        //缓存
        self.cacheBtn = [DIYButton buttonWithType:UIButtonTypeCustom];
        _cacheBtn.frame = CGRectMake(otherBtnWidth * 2 + 10, otherBtnHeight, otherBtnWidth, 20);
        _cacheBtn.icon.image = [UIImage imageNamed:@"download"];
        _cacheBtn.iconSelected.image = [UIImage imageNamed:@"downloadCompleted"];
        _cacheBtn.textLabel.text = @"  缓存";
        [_cacheBtn addTarget:self action:@selector(cache:) forControlEvents:UIControlEventTouchUpInside];
        [_backgroundImageView addSubview:_cacheBtn];
    }
    return self;
}


#pragma mark - 控件赋值方法

- (void)setModel:(CategoaryModel *)model {
    //检查下载状态
    CategoaryModel *categoaryModel = [DB findDownloadComplated:model.playUrl];
    if (categoaryModel) {   //如果已经存在
        model = nil;    //原来的滞空
        model = categoaryModel; //把数据库中的model赋值给我们的model
        self.cacheBtn.selected = YES;
        self.cacheBtn.textLabel.text = @"  已缓存";
        self.cacheBtn.userInteractionEnabled = NO;
    }
    //如果正在下载显示下载状态
    TotalDownloader *total = [TotalDownloader shareTotalDownloader];
    Download *download = [total findDownloadingWithURL:model.playUrl];
    if (download) {
        self.cacheBtn.userInteractionEnabled = NO;  //如果已经存在下载。button不让用户操作
        //如果已经存在下载。但是网络很卡，(下载中的)一次的赋值都没有走
        self.cacheBtn.textLabel.text = [NSString stringWithFormat:@"  %d%%",(int)download.progress];
        [self downloadingWithDownload:download button:self.cacheBtn];
    }
    //检查是否收藏
    CategoaryModel *audioMusicModel = [DB findMovieCollection:model.playUrl];
    if (audioMusicModel) {
        model = nil;
        model = audioMusicModel;
        self.collectionBtn.selected = YES;
        self.collectionBtn.textLabel.text = @"  已收藏";
    }
    _model = model;
    _titleLabel.text = model.title;
    [_categoryLabel detailWithStyle:model.category time:model.duration];
    _infoLabel.text = model.myDescription;
    [_templmageView sd_setImageWithURL:[NSURL URLWithString:model.coverBlurred] placeholderImage:[UIImage imageNamed:@"CategoryPlaceholder"]];
    _bgImage.url = model.coverForDetail;
    //根据字符串求高度
    CGFloat infoHeight = [self stringHeightForFont:self.infoLabel.font string:model.myDescription].height;
    self.infoLabel.height = infoHeight;
    CGFloat lineWidth = [self stringHeightForFont:self.titleLabel.font string:model.title].width;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, self.titleLabel.y + self.backgroundImageView.height / 250 * 37.5, lineWidth * 0.7, 1)];
    lineView.alpha = 0.8;
    lineView.backgroundColor = [UIColor lightGrayColor];
    [_backgroundImageView addSubview:lineView];
}

- (CGSize)stringHeightForFont:(UIFont *)font string:(NSString *)string {
    return [string boundingRectWithSize:CGSizeMake(self.bounds.size.width - 20, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
}

#pragma mark - 响应方法

//点击播放
- (void)startPlay {
    if ([_delegate respondsToSelector:@selector(playMovie:)]) {
        [_delegate playMovie:self.model];
    }
}

//收藏
- (void)collection_:(DIYButton *)button {
    button.selected = !button.selected;
    if ([DB findMovieCollection:self.model.playUrl] == nil) {
        [DB insertMovieCollection:self.model];
    } else {
        [DB deleteMovieCollection:self.model.playUrl];
    }
}

//分享
- (void)share {
    if ([_delegate respondsToSelector:@selector(share)]) {
        [_delegate share];
    }
}

//缓存
- (void)cache:(DIYButton *)button {
    //第一次下载添加到下载中数据表
    [DB insertDownloading:self.model];
    // 避免下载中再次操作
    button.userInteractionEnabled = NO;
    //获取下载器的单例
    TotalDownloader *total = [TotalDownloader shareTotalDownloader];
    //创建一缓存单例
    Download *download = [total addDownloadingWithURL:self.model.playUrl];
    //手动开始
    [download start];
    //下载的状态
    [self downloadingWithDownload:download button:button];
}

//当前下载的状态
- (void)downloadingWithDownload:(Download *)download button:(DIYButton *)button{
    [download didFinishDownload:^(NSString *savePath, NSString *url) {
        button.selected = YES;
        button.textLabel.text = @"  已缓存";
        self.model.save = savePath;
        [DB insertDownloadComplated:self.model];
    } downloading:^(long long bytesWritten, NSInteger progress) {
        button.textLabel.text = [NSString stringWithFormat:@"  %ld%%",progress];
    }];
}

@end
