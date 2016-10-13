//
//  DownloadCell.m
//  QZX_Reader
//
//  Created by zhangsiyao on 15/10/4.
//  Copyright © 2015年 ZhangSiYao. All rights reserved.
//

#import "DownloadCell.h"
#import "TotalDownloader.h"
#import "UIView+Frame.h"
#import "LayoutMacro.h"
#import "DB.h"

@interface DownloadCell ()

@property (strong, nonatomic) UIView *bgView;   //一个蒙板。显示进度条的一个蒙板
@property (strong, nonatomic) UIButton *startBtn;   //开始暂停的按钮
@property (strong, nonatomic) UIButton *deleteBtn;  //删除按钮
@property (strong, nonatomic) Download *download;   //下载的类
@property (copy, nonatomic) DownloadComplated complated;
@property (copy, nonatomic) DeleteDownload deleteDownload;

@end

@implementation DownloadCell

//重写init方法来布局视图
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //创建下载进度条
        CGFloat height = kScreenWidth / 1242 * 777;
        self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, (int)height)];
        self.bgView.backgroundColor = [UIColor blackColor];
        self.bgView.alpha = 0.4;
        [self addSubview:self.bgView];
        
        //创建开始暂停按钮
        self.startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.startBtn.frame = CGRectMake(0, 0, 30, 30);
        [self.startBtn setImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
        [self.startBtn setImage:[UIImage imageNamed:@"play1"] forState:UIControlStateSelected];
        [self.startBtn addTarget:self action:@selector(start:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.startBtn];
        
        //创建删除按钮
        self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.deleteBtn.frame = CGRectMake(0, 0, 30, 30);
        self.deleteBtn.center = CGPointMake(kScreenWidth / 2, height / 4 * 1);  //中间偏下
        [self.deleteBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        [self.deleteBtn addTarget:self action:@selector(deleteDownload:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.deleteBtn];
    }
    return self;
}

#pragma mark - 下载中的方法
- (void)start:(UIButton *)btn {
    if (btn.selected) {
        //拿到沙盒中下载中断的Data继续下载
        NSData *data = [NSKeyedUnarchiver unarchiveObjectWithFile:self.model.dataPath];
        [self.download resume:data];
    } else {    //暂停
        [self.download suspend];
    }
    btn.selected = !btn.selected;
}


#pragma mark - 删除下载的方法
- (void)deleteDownload:(UIButton *)btn {
    self.deleteDownload(self.indexPath);    //回调
}


#pragma mark - 重写model的set方法 -
- (void)setModel:(CategoaryModel *)model {
    //写else是为了我们 重用机制 假如重用过来的按钮已经显示。这边只是做了一个显示的操作。并没有走else的话，我们的按钮仍然是显示的状态。判断虽然是走过了
    if (model.save == nil) {    //代表正在下载
        //显示我们的视图
        self.startBtn.hidden = NO;
        self.bgView.hidden = NO;
        //获取下载
        Download *download = [[TotalDownloader shareTotalDownloader] findDownloadingWithURL:model.playUrl];
        //我们的download有个progress的属性,之前写着这个属性的作用是防止网络慢的时候。一次赋值都没有，显示的还是原来的值
        //第一次赋初值
        self.bgView.width = kScreenWidth * (download.progress / 100.0);
        self.startBtn.center = CGPointMake(self.bgView.width, self.bgView.height / 2);
        //因为系统判断我们用 cancelByProducingResumeData:^(NSData *resumeData) 这个方法后，状态变成了一个NSURLSessionTaskStateCompleted 而不是暂停的状态。所以我们用这个判断
        //或的判断。是重新进入后的判断。
        if (download.state == NSURLSessionTaskStateCompleted || download.state == NSURLSessionTaskStateSuspended) {
            self.startBtn.selected = YES;
            self.bgView.width = kScreenWidth * (model.progress / 100.0);
            self.startBtn.center = CGPointMake(self.bgView.width, self.bgView.height / 2);
        }
        [download didFinishDownload:^(NSString *savePath, NSString *url) {
            //为什么写 model.save 而不是 self.model.save因为下面有[super setModel]
            model.save = savePath;
            [DB insertDownloadComplated:model]; //保存数据库
            if (self.complated) {   //回调
                self.complated(self.indexPath);
            }
        } downloading:^(long long bytesWritten, NSInteger progress) {
            //动态改变我们的坐标
            //为啥加一个100.0  因为两个int相除，得到的还是int
            self.bgView.width = kScreenWidth * (progress / 100.0);
            self.startBtn.center = CGPointMake(kScreenWidth * (progress / 100.0), self.bgView.height / 2);
        }];
        self.download = download;   //给属性赋值
    } else {    //隐藏我们的视图
        self.startBtn.hidden = YES;
        self.bgView.hidden = YES;
    }
    [super setModel:model];
}


// 下载完成的block方法和删除的block
- (void)downloadComplated:(DownloadComplated)complated delete:(DeleteDownload)deleteDownload {
    //给block赋值
    self.complated = complated;
    self.deleteDownload = deleteDownload;
}


@end
