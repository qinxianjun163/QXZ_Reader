//
//  SubscriptionController.m
//  ReaderThreeTest
//
//  Created by 肖冯敏 on 15/9/14.
//  Copyright (c) 2015年 o‘clock. All rights reserved.
//

#import "SubscriptionController.h"
#import "ShowView.h"
#import "ReadCatagoryViewController.h"
#import "JSonForReader.h"
#import "UIView+Frame.h"
#import "LayoutMacro.h"
#import "UIImage+WebP.h"
#import "UIColor+InvertColor.h"
#import "ChangeBackGroundColor.h"

@interface SubscriptionController () <UIPickerViewDataSource, UIPickerViewDelegate, NSURLSessionDownloadDelegate> {
    NSInteger sectionForComponent; //滚轮的数目
    NSInteger rowForComponent; //每个滚轮中item的条数
    
    NSString *tid;
    NSString *tname;
    NSString *subnum;
}

@property (nonatomic, strong) UIPickerView *pickerView; //滚轮视图
@property (nonatomic, strong) ShowView *showView;  //展示视图 (显示在屏幕上方的试图)

@property (nonatomic, strong) NSMutableArray *sectionArray; //存放滚轮的数据
@property (nonatomic, strong) NSMutableArray *rowArray;   //存放 第二个滚轮中的数据
@property (nonatomic, strong) NSArray *totalArray;    //存发所有数据的数组

@property (strong, nonatomic) NSURLSessionDownloadTask *task;
@property (strong, nonatomic) NSURLSession *session;

@end

@implementation SubscriptionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //解析 与请求
    [self createData];
    //设置 pickerView
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height / 2, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height / 2)];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [self.view addSubview:self.pickerView];
    [self pickerView:self.pickerView didSelectRow:0 inComponent:1];
    
    //设置展示 视图
    self.showView = [[ShowView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight / 2)];
    self.showView.titleLabel.text = [[[self.totalArray[0] objectForKey:@"tList"] objectAtIndex:0] objectForKey:@"tname"];
    self.showView.describeLabel.text = [[[self.totalArray[0] objectForKey:@"tList"] objectAtIndex:0] objectForKey:@"alias"];
    self.showView.subnumLabel.text = [NSString stringWithFormat:@"%@订阅", [[[self.totalArray[0] objectForKey:@"tList"] objectAtIndex:0] objectForKey:@"subnum"]];
    [self.view addSubview:self.showView];
    //添加手势, 点击展示的时候 跳转页面.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(presentToReadCategoryController)];
    [self.showView addGestureRecognizer:tap];
    
    UIImageView *backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Back_Gray"]];
    backImageView.frame = CGRectMake(10, 35, 20, 20);
    [self.view addSubview:backImageView];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    backButton.frame = CGRectMake(10, 35, 70, 20);
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    backButton.tintColor = [UIColor grayColor];
    [backButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
}


#pragma mark - 懒加载

- (NSMutableArray *)sectionArray {
    if (!_sectionArray) {
        self.sectionArray = [NSMutableArray array];
    }
    return _sectionArray;
}

//懒加载
- (NSMutableArray *)rowArray {
    if (!_rowArray) {
        self.rowArray = [NSMutableArray array];
    }
    return _rowArray;
}

- (void)createData {
    //将请求的数据写入coreData 否决: 数据库中不能直接写入数组, 那么将data写入本地.
    //先反归档, 获取data 如果data没有的话, 进行请求
    if ([JSonForReader deArchiver]) {
        NSData *data = [JSonForReader deArchiver];
        self.totalArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    }
    else {
        NSString *urlStr = @"http://c.m.163.com/nc/topicset/ios/v4/subscribe/read/all.html";
        NSURL *totalUrl = [NSURL URLWithString:urlStr];
        NSURLRequest *request = [NSURLRequest requestWithURL:totalUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:2];
        NSURLSession *session = [NSURLSession sharedSession];
        [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            [JSonForReader archiver:data];
            self.totalArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            [self.pickerView reloadAllComponents];
        }] resume];;
    }
}

- (void)dismiss {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)presentToReadCategoryController {
    ReadCatagoryViewController *readCatagoryVC = [[ReadCatagoryViewController alloc] init];
    readCatagoryVC.model = [[ReadListModel alloc] initWithDictionary:[[self.totalArray[sectionForComponent] objectForKey:@"tList"] objectAtIndex:rowForComponent]];
    [self.navigationController pushViewController:readCatagoryVC animated:YES];
}

//PickerView 的代理方法 放回pickerViewCompent的个数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

//设置每个compent的大小
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 0) {
        return [UIScreen mainScreen].bounds.size.width / 4;
    } else {
        return [UIScreen mainScreen].bounds.size.width / 4 * 3;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.totalArray.count;
    }
    else {
        return [[self.totalArray[sectionForComponent] objectForKey:@"tList"] count];    //这里只用设定默认的初始 位置的count 其他用监听
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [self.totalArray[row] objectForKey:@"cName"];
    } else {
        // 初始设置
        return [[[self.totalArray[sectionForComponent] objectForKey:@"tList"] objectAtIndex:row] objectForKey:@"tname"];
    }
}

//显示正在选择中的 row
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {   //section 放在第一个compent中
        sectionForComponent = row;
        [self.pickerView reloadComponent:1];
        [self pickerView:self.pickerView didSelectRow:0 inComponent:1];
        [self.pickerView selectRow:0 inComponent:1 animated:YES];
        self.showView.titleLabel.text = [[[self.totalArray[sectionForComponent] objectForKey:@"tList"] objectAtIndex:0] objectForKey:@"tname"];
        self.showView.describeLabel.text = [[[self.totalArray[sectionForComponent] objectForKey:@"tList"] objectAtIndex:0] objectForKey:@"alias"];
    }
    if (component == 1) { //row 放在第二个compent中
        rowForComponent = row;
        self.showView.titleLabel.text = [[[self.totalArray[sectionForComponent] objectForKey:@"tList"] objectAtIndex:rowForComponent] objectForKey:@"tname"];
        self.showView.describeLabel.text = [[[self.totalArray[sectionForComponent] objectForKey:@"tList"] objectAtIndex:rowForComponent] objectForKey:@"alias"];
        //加载图片
        tname = [[[self.totalArray[sectionForComponent] objectForKey:@"tList"] objectAtIndex:rowForComponent] objectForKey:@"tname"];
        tid = [[[self.totalArray[sectionForComponent] objectForKey:@"tList"] objectAtIndex:rowForComponent] objectForKey:@"tid"];
        subnum = [[[self.totalArray[sectionForComponent] objectForKey:@"tList"] objectAtIndex:rowForComponent] objectForKey:@"subnum"];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://s.cimg.163.com/pi/img3.cache.netease.com/m/newsapp/topic_icons/%@.png.100x100.75.auto.webp", tid]];
        NSURLSessionConfiguration *cfg = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.session = [NSURLSession sessionWithConfiguration:cfg delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        self.task = [self.session downloadTaskWithURL:url];
        [self.task resume];
        //订阅数量
        self.showView.subnumLabel.text = [NSString stringWithFormat:@"%@订阅", subnum];
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location{
    NSString *cache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [cache stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.webp", tname]];
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:filePath]) {
        [fm moveItemAtPath:location.path toPath:filePath error:nil];
    }
    self.showView.imageSrcView.image = [UIImage imageWithWebP:filePath];
    self.showView.backgroundColor = [UIColor colorWithPatternImage:self.showView.imageSrcView.image];
    UIColor *changeColor = [ChangeBackGroundColor mostColor:self.showView.imageSrcView.image];
    self.pickerView.backgroundColor = [[[UIColor alloc] brightnessColor:changeColor brightness:0.3] colorWithAlphaComponent:0.3];
}

@end
