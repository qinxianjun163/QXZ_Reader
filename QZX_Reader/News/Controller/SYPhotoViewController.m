//
//  SYPhotoViewController.m
//  QZX_Reader
//
//  Created by zhangsiyao on 15/9/17.
//  Copyright (c) 2015年 ZhangSiYao. All rights reserved.
//

#import "SYPhotoViewController.h"
#import "UIImageView+WebCache.h"
#import "SYHTTPManager.h"
#import "SYPhotoDetail.h"
#import "UIView+Frame.h"
#import "SYReplyModel.h"
#import "SYReplyViewController.h"
#import "MJExtension.h"
#import "UPStackMenu.h"
#import "LayoutMacro.h"
#import "SYCreatKVNProgressUI.h"
#import "SYCollected.h"
#import "UMSocial.h"

@interface SYPhotoViewController () <UIScrollViewDelegate, UPStackMenuDelegate, UMSocialUIDelegate> {
    BOOL isHidden;
    UIView *contentView;
    UPStackMenu *stack;
    UPStackMenuItem *collectedItem;
    UIVisualEffectView *buttonBgView;
    BOOL isCollected;
}

@property (weak, nonatomic) IBOutlet UIScrollView *photoScrollView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentText;
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIButton *replayBtn;
@property (strong, nonatomic) SYReplyModel *replyModel;
@property (strong, nonatomic) NSMutableArray *replyModelArray;
@property (strong, nonatomic) NSArray *newsArray;

@end

@implementation SYPhotoViewController

#pragma mark - 视图加载

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configurationView];
    //取出关键字
    NSString *one  = self.newsModel.photosetID;
    NSString *two = [one substringFromIndex:4];
    NSArray *keyArray = [two componentsSeparatedByString:@"|"];
    CGFloat count = [self.newsModel.replyCount intValue];
    NSString *displayCount = nil;
    if (count > 10000) {
        displayCount = [NSString stringWithFormat:@"%.1f万跟帖", count / 10000];
    }else{
        displayCount = [NSString stringWithFormat:@"%.0f跟帖", count];
    }
    
    [self.replayBtn setTitle:displayCount forState:UIControlStateNormal];
    NSString *url = [NSString stringWithFormat:@"http://c.m.163.com/photo/api/set/%@/%@.json", [keyArray firstObject], [keyArray lastObject]];
    [self sendRequestWithURL:url];
    
    //轻拍手势（隐藏控件）
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tapGR];
    //长按手势（下载图片）
    UILongPressGestureRecognizer *longGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longAction)];
    [self.photoScrollView addGestureRecognizer:longGR];
    //判断收藏状态
    if ([SYCollected isCollectedByFileName:@"PhotoCollectedNewsModel" fileSign:@"title" currentSign:self.newsModel.title]) {
        isCollected = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [SYCreatKVNProgressUI setupBaseKVNProgressUI];    //加载KVNProgressUI
}


#pragma mark - 懒加载

- (NSMutableArray *)replyModelArray {
    if (_replyModelArray == nil) {
        _replyModelArray = [NSMutableArray array];
    }
    return _replyModelArray;
}

- (NSArray *)newsArray {
    if (_newsArray == nil) {
        _newsArray = [NSArray array];
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(9, 1, 1) lastObject];
        NSString *filePath = [docPath stringByAppendingPathComponent:@"SelectURL.plist"];
        _newsArray = [NSArray arrayWithContentsOfFile:filePath];
    }
    return _newsArray;
}


#pragma mark - 事件响应

//轻拍隐藏
- (void)tapAction {
    if (!isHidden) {
        isHidden = YES;
        [UIView animateWithDuration:0.5 animations:^{
            self.headView.alpha = 0;
            self.contentText.alpha = 0;
            self.countLabel.alpha = 0;
        }];
    } else {
        isHidden = NO;
        [UIView animateWithDuration:0.5 animations:^{
            self.headView.alpha = 1.0;
            self.contentText.alpha = 1.0;
            self.countLabel.alpha = 1.0;
        }];
    }
}

//长按照片下载
- (void)longAction {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"将要保存到本地相册" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        int index = (int)self.photoScrollView.contentOffset.x / self.photoScrollView.width;
        NSURL *purl = [NSURL URLWithString:[self.photoSet.photos[index] imgurl]];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:purl]];
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

//保存完毕后调用
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    [KVNProgress showSuccessWithStatus:@"已经保存到照片"];
}

#pragma mark - 调用方法

//视图配置
- (void)configurationView {
    self.contentText.editable = NO;
    self.photoScrollView.tag = 2008;
    self.contentText.textColor = [UIColor colorWithRed:189 / 255.0 green:161 / 255.0 blue:69 / 255.0 alpha:1.0];
    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgImageTest"]];
    bgView.frame = self.view.bounds;
    [self.view addSubview:bgView];
    [self.view sendSubviewToBack:bgView];
    UIVisualEffectView *visualEfView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    visualEfView.frame = self.view.bounds;
    [bgView addSubview:visualEfView];
    self.titleLabel.textColor = [UIColor colorWithRed:189 / 255.0 green:161 / 255.0 blue:69 / 255.0 alpha:1.0];
    self.headView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
}

//发送请求
- (void)sendRequestWithURL:(NSString *)url {
    [[SYHTTPManager manager] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        SYPhotoSet *photoSet = [SYPhotoSet photoSetWith:responseObject];
        self.photoSet = photoSet;
        [self setLabelWithModel:photoSet];
        [self setImageViewWithModel:photoSet];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        (@"Failure = %@", error);
    }];
}

//设置页面文字
- (void)setLabelWithModel:(SYPhotoSet *)photoSet {
    self.titleLabel.text = photoSet.setname;
    //设置新闻内容
    [self setContentWithIndex:0];
    NSString *countNumber = [NSString stringWithFormat:@"1/%d", (int)photoSet.photos.count];
    self.countLabel.text = countNumber;
}

//设置页面的imageView
- (void)setImageViewWithModel:(SYPhotoSet *)photoSet {
    NSUInteger count = self.photoSet.photos.count;
    for (int i = 0; i < count; i++) {
        UIImageView *photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * self.photoScrollView.width, -64, self.photoScrollView.width, self.photoScrollView.height)];
        //设置图片显示格式
        photoImageView.contentMode= UIViewContentModeCenter;
        photoImageView.contentMode= UIViewContentModeScaleAspectFit;
        [self.photoScrollView addSubview:photoImageView];
    }
    //scroll默认有两个子控件
    [self setImageWithIndex:0];
    self.photoScrollView.contentOffset = CGPointZero;
    self.photoScrollView.contentSize = CGSizeMake(self.photoScrollView.width * count, 0);
    self.photoScrollView.showsHorizontalScrollIndicator = NO;
    self.photoScrollView.showsVerticalScrollIndicator = NO;
    self.photoScrollView.pagingEnabled = YES;
}

//滚动完毕时调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int index = self.photoScrollView.contentOffset.x / self.photoScrollView.width;
    //添加图片
    [self setImageWithIndex:index];
    //添加文字
    NSString *countNumber = [NSString stringWithFormat:@"%d/%d", index+1, (int)self.photoSet.photos.count];
    self.countLabel.text = countNumber;
    //添加内容
    [self setContentWithIndex:index];
    [stack closeStack];
}

//添加内容
- (void)setContentWithIndex:(int)index {
    NSString *content = [self.photoSet.photos[index] note];
    NSString *contentTitle = [self.photoSet.photos[index] imgtitle];
    if (content.length != 0) {
        self.contentText.text = content;
    } else {
        self.contentText.text = contentTitle;
    }
    //功能按钮
    [self createMoreBtn];
}

//懒加载添加图片
- (void)setImageWithIndex:(int)i {
    UIImageView *photoImageView = nil;
    if (i == 0) {
        photoImageView = self.photoScrollView.subviews[i + 2];
    } else {
        photoImageView = self.photoScrollView.subviews[i];
    }
    NSURL *purl = [NSURL URLWithString:[self.photoSet.photos[i] imgurl]];
    //没有照片则添加
    if (photoImageView.image == nil) {
        [photoImageView sd_setImageWithURL:purl placeholderImage:[UIImage imageNamed:@"PhotoPlaceholder"]];
    }
}

- (void)hidenVisualEffectView { //隐藏毛玻璃图片
    [stack closeStack];
}

- (void)collectedAction {
    if (!isCollected) {
        [SYCollected collectedByFileName:@"photoCollected" WithDictionary:self.photoSet.keyValues];
        [SYCollected collectedByFileName:@"PhotoCollectedNewsModel" WithDictionary:self.newsModel.keyValues];
        isCollected = YES;
    } else {
        [SYCollected cancelCollectedByFileName:@"photoCollected" fileSign:@"setname" currentSign:self.photoSet.setname];
        [SYCollected cancelCollectedByFileName:@"PhotoCollectedNewsModel" fileSign:@"title" currentSign:self.newsModel.title];
        isCollected = NO;
    }
}

- (void)shareClick {
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"55ffbd59e0f55afb5b000415"
                                      shareText:[NSString stringWithFormat:@"标题：%@\n链接地址：%@", self.newsModel.title, self.newsModel.url]
                                     shareImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.newsModel.imgsrc]]]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina, UMShareToTencent, UMShareToWechatSession, UMShareToWechatTimeline, UMShareToQzone, UMShareToQQ, UMShareToRenren, UMShareToDouban, UMShareToEmail, UMShareToSms, UMShareToFacebook, UMShareToTwitter, nil]
                                       delegate:self];
}

#pragma mark - 更多按钮

//创建方法
- (void)createMoreBtn {
    //创建容器视图
    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [contentView setBackgroundColor:[UIColor colorWithRed:189 / 255.0 green:161 / 255.0 blue:69 / 255.0 alpha:1.0]];
    [contentView.layer setCornerRadius:20];
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cross"]];
    [icon setContentMode:UIViewContentModeScaleAspectFit];
    [icon setFrame:CGRectInset(contentView.frame, 10, 10)];
    [contentView addSubview:icon];
    //创建菜单视图
    stack = [[UPStackMenu alloc] initWithContentView:contentView];
    [stack setCenter:CGPointMake(self.view.frame.size.width / 2, kScreenHeight - 160)];
    [stack setDelegate:self];
    //创建单个菜单
    UPStackMenuItem *shareItem = [[UPStackMenuItem alloc] initWithImage:[UIImage imageNamed:@"shareY"] highlightedImage:nil title:@"分享" font:[UIFont boldSystemFontOfSize:18]];
    if (isCollected) {
        collectedItem = [[UPStackMenuItem alloc] initWithImage:[UIImage imageNamed:@"didCollected"] highlightedImage:[UIImage imageNamed:@"unCollected"] title:@"取消收藏" font:[UIFont boldSystemFontOfSize:18]];
    } else {
        collectedItem = [[UPStackMenuItem alloc] initWithImage:[UIImage imageNamed:@"unCollected"] highlightedImage:[UIImage imageNamed:@"didCollected"] title:@"收藏" font:[UIFont boldSystemFontOfSize:18]];
    }
    UPStackMenuItem *backItem = [[UPStackMenuItem alloc] initWithImage:[UIImage imageNamed:@"back"] highlightedImage:nil title:@"快退" font:[UIFont boldSystemFontOfSize:18]];
    UPStackMenuItem *goItem = [[UPStackMenuItem alloc] initWithImage:[UIImage imageNamed:@"go"] highlightedImage:nil title:@"快进" font:[UIFont boldSystemFontOfSize:18]];
    NSMutableArray *items = [[NSMutableArray alloc] initWithObjects:shareItem, collectedItem, backItem, goItem, nil];
    [items enumerateObjectsUsingBlock:^(UPStackMenuItem *item, NSUInteger idx, BOOL *stop) {
        [item setTitleColor:[UIColor whiteColor]];
    }];
    //配置代码
    [stack setAnimationType:UPStackMenuAnimationType_progressiveInverse];
    [stack setStackPosition:UPStackMenuStackPosition_up];
    [stack setOpenAnimationDuration:.4];
    [stack setCloseAnimationDuration:.4];
    [items enumerateObjectsUsingBlock:^(UPStackMenuItem *item, NSUInteger idx, BOOL *stop) {
        if(idx%2 == 0)
            [item setLabelPosition:UPStackMenuItemLabelPosition_left];
        else
            [item setLabelPosition:UPStackMenuItemLabelPosition_right];
    }];
    [stack addItems:items];
    //添加蒙版视图
    buttonBgView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    buttonBgView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    buttonBgView.hidden = YES;
    //蒙版视图的轻拍手势
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenVisualEffectView)];
    [buttonBgView addGestureRecognizer:tapGR];
    [self.view addSubview:buttonBgView];
    [self.view addSubview:stack];
    [self setStackIconClosed:YES];
}

//调用方法
- (void)setStackIconClosed:(BOOL)closed
{
    UIImageView *icon = [[contentView subviews] objectAtIndex:0];
    float angle = closed ? 0 : (M_PI * (135) / 180.0);
    [UIView animateWithDuration:0.3 animations:^{
        [icon.layer setAffineTransform:CGAffineTransformRotate(CGAffineTransformIdentity, angle)];
    }];
}

//代理方法
- (void)stackMenuWillOpen:(UPStackMenu *)menu
{
    if([[contentView subviews] count] == 0)
        return;
    buttonBgView.hidden = NO;
    [self setStackIconClosed:NO];
}

- (void)stackMenuWillClose:(UPStackMenu *)menu
{
    if([[contentView subviews] count] == 0)
        return;
    buttonBgView.hidden = YES;
    [self setStackIconClosed:YES];
}

- (void)stackMenu:(UPStackMenu *)menu didTouchItem:(UPStackMenuItem *)item atIndex:(NSUInteger)index
{
    buttonBgView.hidden = YES;
    [stack closeStack];
    switch (index) {
        case 3:
        {   //快进
            int index = self.photoScrollView.contentSize.width / self.photoScrollView.width;
            CGFloat contentWidth = self.photoScrollView.contentSize.width;
            [self setImageWithIndex:index - 1];
            [self.photoScrollView setContentOffset:CGPointMake(contentWidth - self.photoScrollView.width, 0) animated:YES];
            NSString *countNumber = [NSString stringWithFormat:@"%d/%d", index, (int)self.photoSet.photos.count];
            self.countLabel.text = countNumber;
            [self setContentWithIndex:index - 1];
        }
            break;
        case 2:
        {   //快退
            [self.photoScrollView setContentOffset:CGPointMake(0 , 0) animated:YES];
            NSString *countNumber = [NSString stringWithFormat:@"%d/%d", (int)index - 1, (int)self.photoSet.photos.count];
            self.countLabel.text = countNumber;
            [self setContentWithIndex:(int)(index - 1)];
        }
            break;
        case 1:
        {   //收藏
            [self collectedAction];
        }
            break;
        case 0:
        {   //分享
            [self shareClick];
        }
        default:
            break;
    }
}

@end
