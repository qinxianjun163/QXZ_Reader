//
//  MoviePlayer.m
//  QZX_Reader
//
//  Created by zhangsiyao on 15/10/3.
//  Copyright © 2015年 ZhangSiYao. All rights reserved.
//

#import "MoviePlayer.h"
#import "DIYButton.h"
#import <MediaPlayer/MediaPlayer.h>
#import "UIView+Frame.h"
#import "UILabel+Categoary.h"
#import "LayoutMacro.h"

@interface MoviePlayer () <SliderDelegate>


#pragma mark - 属性声明

@property (nonatomic, strong) MPMoviePlayerController *moviePlay;   //视频播放视图

@property (nonatomic, strong) UIView *bgView;   //背景View

@property (nonatomic, strong) DIYButton *backBtn;    //返回按钮 + 标题

@property (nonatomic, strong) UIButton *playBtn;    //播放/暂停 按钮

@property (nonatomic, strong) Slider *progress;   //进度条

@property (nonatomic, strong) UISlider *volume; //声音

@property (nonatomic, strong) UILabel *begin;   //已经播放时间

@property (nonatomic, strong) UILabel *end; //剩余时间

@property (nonatomic, strong) UIView *downView; //自定义下方视图

@property (nonatomic, strong) UIView *volumeView;   //声音视图

@property (nonatomic, strong) UIView *headView; //上方视图

@property (nonatomic, strong) NSTimer *timer;   //视频播放进度的定时器，实时获取播放进度

@property (nonatomic, strong) UILabel *fastLabel;   //快进的Label

@property (nonatomic, strong) UISlider *tempSlider;  //接收系统音量的Slider


#pragma mark - 方法声明

- (void)creatMoviePlayWithURL:(NSURL *)url; //创建MoviePlayer

- (void)creatBackgroundView;    //创建播放视图上的View

- (void)tapGR;  //创建点击事件

- (void)creatPauseButton;   //创建开始暂停按钮

- (void)createHeaderView;   //创建上方视图

- (void)createDownView; //创建下方视图

- (void)createVolumeView;   //创建声音视图

- (void)addObserver;    //添加观察者

- (void)panGR;  //创建平移手势

- (void)creatFastLabel; //创建快进视图

@end

@implementation MoviePlayer {
    
    BOOL isMovie;
    
    PanDirection panDirection;//判断哪个方向的枚举
    
    CGFloat topValue;   //水平移动的上一次移动数值
    
    CGFloat volumeValue;    //垂直方向上一次移动数值
    
    BOOL isChange;
}

- (void)dealloc {
    
    self.delegate = nil;
}

//URL类型参数为本地播放预留接口
- (instancetype)initWithFrame:(CGRect)frame URL:(NSURL *)url {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor blackColor];
        
        //1.创建视频播放视图
        [self creatMoviePlayWithURL:url];
        
        //2.添加观察者对象
        [self addObserver];
        
        //3.创建背景视图
        [self creatBackgroundView];
        
        //4.创建返回按钮 + title
        [self createHeaderView];
        
        //5.播放暂停按钮
        [self creatPauseButton];
        
        //6.进度条一行视图
        [self createDownView];
        
        //7.创建声音视图
        [self createVolumeView];
        
        //8.创建快进Label
        [self creatFastLabel];
    }
    return self;
}


#pragma mark - 添加观察者对象

- (void)addObserver {
    
    //观察视频加载完毕后的方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(durationAvaliableNotification:) name:MPMovieDurationAvailableNotification object:self.moviePlay];
    
    //观察视频Size
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MPMovieNaturalSizeAvailableNotification) name:MPMovieNaturalSizeAvailableNotification object:self.moviePlay];
}

//根据宽度适自适应视频高度

- (void)MPMovieNaturalSizeAvailableNotification {
    
    self.moviePlay.view.frame = CGRectMake(0, 0, self.width, self.width * self.moviePlay.naturalSize.height / self.moviePlay.naturalSize.width);
    
    self.moviePlay.view.center = self.center;
}


#pragma mark - 视频加载好后响应的方法

- (void)durationAvaliableNotification:(NSNotification *)notification {
    
    //视频加载完毕后才能响应轻拍手势
    [self tapGR];
    
    //平移手势
    [self panGR];
    
    //设置最大时长
    self.progress.slider.maximumValue = self.moviePlay.duration;
    
    self.progress.slider.minimumValue = 0;
    
    //添加定时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(moviePlayerTimer:) userInfo:nil repeats:YES];
    
    //显示播放时长
    NSString *string = [NSString stringWithFormat:@"%02d:%02d", (int)_moviePlay.duration / 60, (int)_moviePlay.duration % 60];
    
    self.end.text = string;
}


#pragma mark - 定时器响应方法

//1.刷新Slide的Value
//2.刷新缓存条状态
//3.刷新已播放时长的Label
- (void)moviePlayerTimer:(NSTimer *)timer {
    
    //当滑动视图时，不更新slider的value
    if (!isMovie) {
        
        self.progress.slider.value = self.moviePlay.currentPlaybackTime;
    }
    
    CGFloat time = self.moviePlay.currentPlaybackTime;
    
    int minute = (int)time / 60;
    
    int second = (int)time % 60;
    
    //给缓存状态赋值
    self.progress.cache = self.moviePlay.playableDuration;
    
    //为begin赋值
    NSString *string = [NSString stringWithFormat:@"%02d:%02d", minute, second];
    
    self.begin.text = string;
}


#pragma mark - 创建moviePlay

- (void)creatMoviePlayWithURL:(NSURL *)url {
    
    //1.视频播放视图
    self.moviePlay = [[MPMoviePlayerController alloc] initWithContentURL:url];
    
    self.moviePlay.controlStyle = NO;  //样式设置为NO，然后自定义样式
    
    self.moviePlay.view.frame = self.bounds;
    
    [self addSubview:self.moviePlay.view];
    
    [self.moviePlay play];
}


#pragma mark - 创建bgView

- (void)creatBackgroundView {
    
    //创建一个视图的子视图，和父视图等大，frame一定为为self.bounds
    self.bgView = [[UIView alloc] initWithFrame:self.bounds];
    
    self.bgView.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.bgView];
}


#pragma mark - 创建HeaderView

- (void)createHeaderView {
    
    //创建headerView
    self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 55)];
    
    self.headView.backgroundColor = [UIColor clearColor];
    
    //创建自定义返回按钮
    self.backBtn = [DIYButton buttonWithType:UIButtonTypeCustom];
    
    self.backBtn.frame = CGRectMake(15, 15, self.bounds.size.width / 2, 25);
    
    self.backBtn.icon.image = [UIImage imageNamed:@"backBtn"];
    
    [self.backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.headView addSubview:self.backBtn];
    
    [self.bgView addSubview:self.headView];
    
    self.headView.hidden = YES;
}

//backBtn响应事件
- (void)back:(DIYButton *)button {
    
    //暂停视频
    [self.moviePlay stop];
    //停止定时器
    [self.timer invalidate];
    
    if ([self.delegate respondsToSelector:@selector(back)]) {
        [self.delegate back];
    }
}


#pragma mark - 创建playBtn

- (void)creatPauseButton {
    
    //创建button时，使用自己的图片Type类型设置为UIButtonTypeCustom
    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.playBtn.hidden = YES;
    
    self.playBtn.frame = CGRectMake((self.width - 40) / 2, (self.height - 40) / 2, 40, 40);
    
    //播放状态下图片
    [self.playBtn setImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
    
    //暂停状态下图片
    [self.playBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateSelected];
    
    [self.playBtn addTarget:self action:@selector(pause:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bgView addSubview:self.playBtn];
}

//playBtn响应事件
- (void)pause:(UIButton *)button {
    //改变button的图片状态
    button.selected = !button.selected;
    if (button.selected) {
        //调用暂停方法
        [self.moviePlay pause];
    }
    else {
        //调用开始方法
        [self.moviePlay play];
    }
}


#pragma mark - 全屏轻拍手势

- (void)tapGR {
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView)];
    
    [self.bgView addGestureRecognizer:tapGR];
}

//轻拍View隐藏控件
- (void)tapView {
    
    self.playBtn.hidden = !self.playBtn.hidden;
    
    [self otherViewHidden];
    
    if (!self.playBtn.hidden) {
        //5秒后执行隐藏方法
        //先取消之前已经准备的方法，再添加新方法
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hiddenView) object:nil];
        
        [self performSelector:@selector(hiddenView) withObject:nil afterDelay:5];
    }
}

//n秒后执行隐藏
- (void)hiddenView {
    
    self.playBtn.hidden = !self.playBtn.hidden;
    
    [self otherViewHidden];
}

//其他视图的显示根据playBtn决定
- (void)otherViewHidden {
    
    self.downView.hidden = self.playBtn.hidden;
    self.volumeView.hidden = self.playBtn.hidden;
    self.headView.hidden = self.playBtn.hidden;
}


#pragma mark - 自定义下方视图

- (void)createDownView {
    
    //创建下方视图
    self.downView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 80, self.width, 80)];
    
    self.downView.hidden = YES;
    
    self.downView.backgroundColor = [UIColor clearColor];
    
    
    //创建beginLabel
    
    self.begin = [[UILabel alloc] initWithFrame:CGRectMake(15, 30, 50, 20)];
    
    self.begin.textColor = [UIColor whiteColor];
    
    self.begin.font = [UIFont systemFontOfSize:15];
    
    self.begin.textAlignment = NSTextAlignmentCenter;
    
    self.begin.backgroundColor = [UIColor clearColor];
    
    [self.downView addSubview:self.begin];
    
    
    //创建进度条
    
    self.progress = [[Slider alloc] initWithFrame:CGRectMake(80, 30, self.downView.width - 160, 20)];
    
    self.progress.delegate = self;
    
    self.progress.cacheColor = [UIColor cyanColor];
    
    self.progress.slider.maximumTrackTintColor = [UIColor whiteColor];
    
    
    //实时更新滑块
    
    [self.progress.slider addTarget:self action:@selector(progressChangeValue) forControlEvents:UIControlEventValueChanged];
    
    
    //滑动滑块
    
    [self.progress.slider addTarget:self action:@selector(valueChange: event:) forControlEvents:UIControlEventValueChanged];
    
    [self.downView addSubview:self.progress];
    
    
    //创建endLabel
    
    self.end = [[UILabel alloc] initWithFrame:CGRectMake(self.downView.width - 65, 30, 50, 20)];
    
    self.end.textColor = [UIColor whiteColor];
    
    self.end.font = [UIFont systemFontOfSize:15];
    
    self.end.textAlignment = NSTextAlignmentCenter;
    
    self.end.backgroundColor = [UIColor clearColor];
    
    [self.downView addSubview:self.end];
    
    [self.bgView addSubview:self.downView];
}


#pragma mark - 进度条滑动执行方法

- (void)valueChange:(UISlider *)slider event:(UIEvent *)event {
    
    //从event拿到一个touch手势
    UITouch *touch = [[event allTouches] anyObject];
    
    switch (touch.phase) {
        case UITouchPhaseBegan: {
            //开始滑动时停止更新value
            isMovie = YES;
            [self.moviePlay pause];
        }
            break;
            
        case UITouchPhaseMoved:{
            self.moviePlay.currentPlaybackTime = slider.value;
        }
            break;
            
        case UITouchPhaseEnded: {
            [self.moviePlay play];
            isMovie = NO;
            self.moviePlay.currentPlaybackTime = slider.value;
        }
            break;
            
        default: {
            //停止滑动时或划出屏幕时，停止到当前位置，并且改变视频的当前播放进度
            [self.moviePlay play];
            isMovie = NO;
            self.moviePlay.currentPlaybackTime = slider.value;
        }
            break;
    }
}


#pragma mark - 播放进度条响应方法

- (void)progressChangeValue {
    
    CGFloat time = self.progress.slider.value * self.moviePlay.duration;
    
    int minute = (int)time / 60;
    
    int second = (int)time % 60;
    
    NSString *string = [NSString stringWithFormat:@"%02d:%02d", minute, second];
    
    self.begin.text = string;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hiddenView) object:nil];
    
    [self performSelector:@selector(hiddenView) withObject:nil afterDelay:5];
}


#pragma mark - Slider代理方法

//在Slider中将改变的value作为代理传出给调用者享用（点击进度条时使用）
- (void)touchView:(CGFloat)value {
    
    self.moviePlay.currentPlaybackTime = value * self.moviePlay.duration;
}

#pragma mark - 创建声音视图

- (void)createVolumeView {
    
    //创建声音视图
    
    self.volumeView = [[UIView alloc] initWithFrame:CGRectMake(15, self.height / 4, 40, self.height / 2)];
    
    self.volumeView.hidden = YES;
    
    self.volumeView.backgroundColor = [UIColor clearColor];
    
    
    //创建滑块视图
    
    self.volume = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, self.volumeView.height - 60, 20)];
    
    self.volume.userInteractionEnabled = NO;
    
    [self.volume setThumbImage:[UIImage imageNamed:@"sliderView"] forState:UIControlStateNormal];
    
    self.volume.center = CGPointMake(self.volumeView.width / 2, self.volumeView.height / 2);
    
    self.volume.transform = CGAffineTransformMakeRotation(-M_PI_2);
    
    [self.volume setMinimumTrackTintColor:[UIColor whiteColor]];
    
    
    //创建两个声音图标
    
    UIImageView *upImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 20, 20)];
    
    upImageView.image = [UIImage imageNamed:@"iconfont-volumeincrease"];
    
    [self.volumeView addSubview:upImageView];
    
    UIImageView *downImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, self.volumeView.height - 20, 20, 20)];
    
    downImageView.image = [UIImage imageNamed:@"iconfont-volumedecrease"];
    
    [self.volumeView addSubview:downImageView];
    
    [self.volumeView addSubview:self.volume];
    
    [self.bgView addSubview:self.volumeView];
}


#pragma mark - 滑动手势

- (void)panGR {
    
    UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    
    [self.bgView addGestureRecognizer:panGR];
}

- (void)panGesture:(UIPanGestureRecognizer *)pan {
    //根据上次手指的位置获取的偏移量
    CGPoint point = [pan velocityInView:self.bgView];
    //判断touch的状态
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        {
            //在began中判断是哪个方向的手势
            CGFloat x = fabs(point.x);
            CGFloat y = fabs(point.y);
            if (x > y) {
                panDirection = PanDirectionHorizontalMoved;
                //给上次的value赋初值
                topValue = self.moviePlay.currentPlaybackTime;
            }
            else if (x < y) {
                panDirection = PanDirectionVerticalMoved;
            }
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            switch (panDirection) {
                case PanDirectionHorizontalMoved:
                {
                    [self horizontalMoved:point.x];
                    break;
                }
                default:
                {
                    [self verticalMoved:point.y];
                    self.volumeView.hidden = NO;
                    break;
                }
            }
            break;
        }
        default:
            if (panDirection == PanDirectionHorizontalMoved) {
                //结束时，跳转视频进度
                self.moviePlay.currentPlaybackTime = topValue;
                topValue = 0;
            } else {
                if (self.playBtn.hidden) {
                    self.volumeView.hidden = YES;
                }
            }
            break;
    }
}


#pragma mark - 水平方向移动的方法

- (void)horizontalMoved:(float)value {
    
    //水平移动后，隐藏除了快进条以外的视图
    
    for (UIView *view in self.bgView.subviews) {
        view.hidden = YES;
    }
    
    self.fastLabel.hidden = NO;
    
    
    //移动时快进
    
    topValue += value / self.moviePlay.duration;
    
    
    //不超过视频时长范围
    
    if (topValue < 0) {
        topValue = 0;
    } else if (topValue > self.moviePlay.duration) {
        topValue = self.moviePlay.duration;
    }
    
    self.begin.text = [self timeStrWithTime:topValue];
    
    NSString *string = [self timeStrWithTime:(int)topValue];
    
    NSString *string1 = [self timeStrWithTime:(int)self.moviePlay.duration];
    
    if (value > 0) {
        self.fastLabel.text = [NSString stringWithFormat:@">>\t\t%@:%@", string, string1];
    } else {
        self.fastLabel.text = [NSString stringWithFormat:@"<<\t\t%@:%@", string, string1];
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hiddenFastLabel) object:nil];
    
    [self performSelector:@selector(hiddenFastLabel) withObject:nil afterDelay:2];
    
}

//创建快进显示框
- (void)creatFastLabel {
    
    self.fastLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.width - 200) / 2, self.height / 4 * 3, 200, 30)];
    
    self.fastLabel.font = [UIFont boldSystemFontOfSize:20];
    
    self.fastLabel.textColor = [UIColor whiteColor];
    
    self.fastLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.bgView addSubview:self.fastLabel];
    
    
    MPVolumeView *mpVolumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(-100, -100, 1, 1)]; //将创建的声音控件移动到可视范围外
    
    for (UIView *view in mpVolumeView.subviews) {
        
        
        //获取到UISlider
        
        if ([view isKindOfClass:[UISlider class]]) {
            
            self.tempSlider = (UISlider *)view;
        }
    }
}

- (void)hiddenFastLabel {
    
    _fastLabel.hidden = YES;
}

#pragma mark - 垂直方向移动的方法

- (void)verticalMoved:(float)value {
    
    self.tempSlider.value += -value / self.height / 10;
    
    self.volume.value += -value / self.height / 10;
}


#pragma mark - 其他方法

//头尾时间显示格式转换
- (NSString *)timeStrWithTime:(int)time {
    
    NSString *min = [NSString stringWithFormat:@"%02d", time / 60];
    
    NSString *s = [NSString stringWithFormat:@"%02d", time % 60];
    
    return [NSString stringWithFormat:@"%@:%@", min, s];
}

//title的getter方法
- (void)setTitle:(NSString *)title {
    
    _title = title;
    
    self.backBtn.textLabel.text = [NSString stringWithFormat:@"\t%@", title];
    
    self.backBtn.textLabel.font = [UIFont systemFontOfSize:18];
    
    self.backBtn.textLabel.textColor = [UIColor colorWithRed:189 / 255.0 green:161 / 255.0 blue:69 / 255.0 alpha:1.0];
}

@end
