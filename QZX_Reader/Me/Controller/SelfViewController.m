//
//  SelfViewController.m
//  QZX_Reader
//
//  Created by zhangsiyao on 15/9/18.
//  Copyright © 2015年 ZhangSiYao. All rights reserved.
//

#import "SelfViewController.h"
#import "LayoutMacro.h"
#import "UIView+Frame.h"
#import "SYDetailController.h"
#import "SYPhotoViewController.h"
#import "SYPhotoSet.h"
#import "UIViewController+MJPopupViewController.h"
#import "SetViewController.h"
#import "SDImageCache.h"
#import "JDStatusBarNotification.h"
#import "KVNProgress.h"
#import "SwitchSingleInstance.h"
#import "UIImage+SYArchver.h"
#import "DB.h"
#import "MovieCollected.h"
#import "ReadCollected.h"
#import "CollectionReader.h"

typedef NS_ENUM(NSInteger, PickerTypt) {
    PickerTyptUserPhoto = 0,
    PickerTyptBgPicture
};

@interface SelfViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    PickerTypt pickerTypt;  //判断Picker执行的代理方法
}

@property (strong, nonatomic) IBOutlet UIImageView *bgImageView;
@property (strong, nonatomic) UITableView *newsTableView;
@property (strong, nonatomic) NSMutableArray *newsDataArray;
@property (strong, nonatomic) NSMutableArray *photoDataArray;
@property (strong, nonatomic) NSMutableArray *photoModelDataArray;
@property (strong, nonatomic) NSMutableArray *allDataArray;
@property (strong, nonatomic) NSMutableArray *newsHistoryArray;

@property (strong, nonatomic) UIView *userIView;    //用户视图
@property (strong, nonatomic) UIImageView *userPhoto;   //用户头像视图
@property (strong, nonatomic) UIView *collectedBgView;  //收藏标签的背景View
@property (strong, nonatomic) UIScrollView *collectedScrollView;    //收藏页的滚动视图
@property (strong, nonatomic) UIView *indicatorView;    //标签下方指示视图
@property (strong, nonatomic) UIVisualEffectView *visualEfView; //滑动视图的蒙版视图

@property (strong, nonatomic) SetViewController *setVC;

@property (strong, nonatomic) UIButton *newsBtn;    //新闻收藏按钮
@property (strong, nonatomic) UIButton *readBtn;    //阅读收藏按钮
@property (strong, nonatomic) UIButton *videoBtn;   //视频收藏按钮
@property (strong, nonatomic) UIView *nightView;    //夜间模式View

@property (strong, nonatomic) MovieCollected *movieTableView;
@property (strong, nonatomic) ReadCollected *readTableView;
@property (strong, nonatomic) NSManagedObjectContext *context;

@end

@implementation SelfViewController

static NSString *reuserIdentifier = @"Cell";
static NSString *headerReuserIdentifier = @"Header";


#pragma mark - 视图加载方法

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    titleView.text = @"Self";
    titleView.font = [UIFont fontWithName:@"SnellRoundhand-Black" size:20];
    titleView.textColor = [UIColor colorWithRed:189 / 255.0 green:161 / 255.0 blue:69 / 255.0 alpha:1.0];
    self.navigationItem.titleView = titleView;
    //添加数据
    [self createNewsData];
    [self createPhotoData];
    [self createPhotoModelData];
    [self createNewsHistoryData];
    self.allDataArray = [NSMutableArray arrayWithObjects:self.newsDataArray, self.photoDataArray, nil];
    //tableView
    self.newsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 220 - 29) style:UITableViewStyleGrouped];
    self.newsTableView.backgroundColor = [UIColor clearColor];
    self.newsTableView.delegate = self;
    self.newsTableView.dataSource = self;
    [self.newsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuserIdentifier];
    [self.newsTableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:headerReuserIdentifier];
    self.movieTableView = [[MovieCollected alloc] initWithStyle:UITableViewStyleGrouped];
    self.movieTableView.view.frame = CGRectMake(kScreenWidth * 2, 0, kScreenWidth, kScreenHeight - 220 - 29);
    [self addChildViewController:self.movieTableView];
    self.readTableView = [[ReadCollected alloc] initWithStyle:UITableViewStyleGrouped];
    self.readTableView.view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight - 220 - 29);
    [self addChildViewController:self.readTableView];
    //初始化视图配置
    [self createView];
    //创建夜间模式视图
    self.nightView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.nightView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.nightView.userInteractionEnabled = NO;
    self.nightView.hidden = YES;
    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
    [window addSubview:self.nightView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self createNewsData];
    [self createPhotoData];
    [self createPhotoModelData];
    [self createNewsHistoryData];
    self.allDataArray = [NSMutableArray arrayWithObjects:self.newsDataArray, self.photoDataArray, nil];
    [self.newsTableView reloadData];
    [self.movieTableView.tableView reloadData];
    self.movieTableView.dataArray = [DB allMovieCollection];
    [self.readTableView.tableView reloadData];
    self.readTableView.dataArray = [CollectionReader selectAllCollectionWithContext:self.context];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.movieTableView.dataArray = [DB allMovieCollection];
    self.readTableView.dataArray = [CollectionReader selectAllCollectionWithContext:self.context];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


#pragma makr - 懒加载方法

- (NSMutableArray *)newsDataArray {
    if (_newsDataArray == nil) {
        _newsDataArray = [NSMutableArray array];
    }
    return _newsDataArray;
}

- (NSMutableArray *)photoDataArray {
    if (_photoDataArray == nil) {
        _photoDataArray = [NSMutableArray array];
    }
    return _photoDataArray;
}

- (NSMutableArray *)photoModelDataArray {
    if (_photoModelDataArray == nil) {
        _photoModelDataArray = [NSMutableArray array];
    }
    return _photoModelDataArray;
}

- (NSMutableArray *)newsHistoryArray {
    if (_newsHistoryArray == nil) {
        _newsHistoryArray = [NSMutableArray array];
    }
    return _newsHistoryArray;
}

- (NSManagedObjectContext *)context {
    if (_context == nil) {
        self.context = [NSManagedObjectContext new];
        [CollectionReader creatCollectionWithContext:self.context];
    }
    return _context;
}

#pragma mark - 数据加载方法

- (void)createNewsData {
    NSString *doc = [NSSearchPathForDirectoriesInDomains(9, 1, 1) lastObject];
    NSString *filePath = [doc stringByAppendingPathComponent:[NSString stringWithFormat:@"test.plist"]];
    self.newsDataArray = [NSMutableArray arrayWithContentsOfFile:filePath];
}

- (void)createPhotoData {
    NSString *doc = [NSSearchPathForDirectoriesInDomains(9, 1, 1) lastObject];
    NSString *filePath = [doc stringByAppendingPathComponent:[NSString stringWithFormat:@"photoCollected.plist"]];
    self.photoDataArray = [NSMutableArray arrayWithContentsOfFile:filePath];
}

- (void)createPhotoModelData {
    NSString *doc = [NSSearchPathForDirectoriesInDomains(9, 1, 1) lastObject];
    NSString *filePath = [doc stringByAppendingPathComponent:[NSString stringWithFormat:@"PhotoCollectedNewsModel.plist"]];
    self.photoModelDataArray = [NSMutableArray arrayWithContentsOfFile:filePath];
}

- (void)createNewsHistoryData {
    NSString *doc = [NSSearchPathForDirectoriesInDomains(9, 1, 1) lastObject];
    NSString *filePath = [doc stringByAppendingPathComponent:[NSString stringWithFormat:@"NewsHistory.plist"]];
    self.newsHistoryArray = [NSMutableArray arrayWithContentsOfFile:filePath];
}

#pragma mark - 初始化视图配置

- (void)createView {
    //背景视图
    self.bgImageView.image = [UIImage getImageWithSavePhotoName:@"bgPhoto.jpg"];
    //用户信息视图
    self.userIView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 220)];
    self.userIView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    [self.view addSubview:self.userIView];
    //蒙版视图
    self.visualEfView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    CGFloat visualEfViewY = self.userIView.y + self.userIView.height;
    self.visualEfView.frame = CGRectMake(0, visualEfViewY, kScreenWidth, kScreenHeight - visualEfViewY);
    [self.view addSubview:self.visualEfView];
    //滚动收藏页视图
    self.collectedScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.userIView.height, kScreenWidth, kScreenHeight - self.userIView.height)];
    self.collectedScrollView.delegate = self;
    self.collectedScrollView.pagingEnabled = YES;
    self.collectedScrollView.contentSize = CGSizeMake(kScreenWidth * 3, 0);
    [self.collectedScrollView addSubview:self.newsTableView];
    [self.collectedScrollView addSubview:self.movieTableView.tableView];
    [self.collectedScrollView addSubview:self.readTableView.tableView];
    [self.view addSubview:self.collectedScrollView];
    //用户头像
    UIView *photoView = [[UIView alloc] init];
    photoView.frame = CGRectMake(0, 0, 70, 70);
    photoView.center = CGPointMake(self.userIView.center.x, self.userIView.center.y - 20);
    photoView.layer.cornerRadius = photoView.width / 2.0;
    photoView.backgroundColor = [UIColor clearColor];
    photoView.clipsToBounds = YES;
    [self.userIView addSubview:photoView];
    self.userPhoto = [[UIImageView alloc] initWithImage:[UIImage getImageWithSavePhotoName:@"userPhoto.jpg"]];
    self.userPhoto.frame = photoView.bounds;
    self.userPhoto.layer.cornerRadius = self.userPhoto.width / 2.0;
    self.userPhoto.userInteractionEnabled = YES;
    [photoView addSubview:self.userPhoto];
    UITapGestureRecognizer *TapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeUserPhoto)];
    [self.userPhoto addGestureRecognizer:TapGR];
    //登录按钮
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    loginBtn.backgroundColor = [UIColor clearColor];
    loginBtn.tintColor = [UIColor colorWithRed:189 / 255.0 green:161 / 255.0 blue:69 / 255.0 alpha:1.0];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.frame = CGRectMake(0, 0, 100, 25);
    loginBtn.center = self.userIView.center;
    loginBtn.y = photoView.y + photoView.height + 20;
    [self.userIView addSubview:loginBtn];
    //收藏标签视图
    self.collectedBgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.userIView.height - 25, kScreenWidth, 25)];
    self.collectedBgView.backgroundColor = [UIColor clearColor];
    [self.userIView addSubview:self.collectedBgView];
    //创建标签
    CGFloat labelWidth = kScreenWidth / 3.0;
    self.newsBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.newsBtn.frame = CGRectMake(0, 0, labelWidth, 25);
    [self.newsBtn setTitle:@"新闻收藏" forState:UIControlStateNormal];
    self.newsBtn.tintColor = [UIColor colorWithRed:189 / 255.0 green:161 / 255.0 blue:69 / 255.0 alpha:1.0];
    [self.newsBtn addTarget:self action:@selector(newsCollected) forControlEvents:UIControlEventTouchUpInside];
    [self.collectedBgView addSubview:self.newsBtn];
    
    self.readBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.readBtn.frame = CGRectMake(labelWidth * 1, 0, labelWidth, 25);
    [self.readBtn setTitle:@"阅读收藏" forState:UIControlStateNormal];
    self.readBtn.tintColor = [UIColor colorWithRed:189 / 255.0 green:161 / 255.0 blue:69 / 255.0 alpha:1.0];
    [self.readBtn addTarget:self action:@selector(readCollected) forControlEvents:UIControlEventTouchUpInside];
    [self.collectedBgView addSubview:self.readBtn];
    
    self.videoBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.videoBtn.frame = CGRectMake(labelWidth * 2, 0, labelWidth, 25);
    [self.videoBtn setTitle:@"视频收藏" forState:UIControlStateNormal];
    self.videoBtn.tintColor = [UIColor colorWithRed:189 / 255.0 green:161 / 255.0 blue:69 / 255.0 alpha:1.0];
    [self.videoBtn addTarget:self action:@selector(videoCollected) forControlEvents:UIControlEventTouchUpInside];
    [self.collectedBgView addSubview:self.videoBtn];
    //设置按钮
    UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    setBtn.frame = CGRectMake(kScreenWidth - 60, 30, 40, 20);
    [setBtn setTitle:@"设置" forState:UIControlStateNormal];
    setBtn.tintColor = [UIColor colorWithRed:189 / 255.0 green:161 / 255.0 blue:69 / 255.0 alpha:1.0];
    [setBtn addTarget:self action:@selector(setClick) forControlEvents:UIControlEventTouchUpInside];
    [self.userIView addSubview:setBtn];
    //标签下方指示器视图
    self.indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 67, 2)];
    self.indicatorView.center = CGPointMake(self.newsBtn.center.x, self.userIView.height - 1);
    self.indicatorView.backgroundColor = [UIColor colorWithRed:189 / 255.0 green:161 / 255.0 blue:69 / 255.0 alpha:1.0];
    [self.userIView addSubview:self.indicatorView];
}

#pragma mark - 事件响应

- (void)login {
    UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"要不下个版本给您弄个" delegate:self cancelButtonTitle:@"知道哒" otherButtonTitles:nil, nil];
    [alerView show];
}

- (void)newsCollected {
    self.collectedScrollView.contentOffset = CGPointMake(0, 0);
    self.indicatorView.center = CGPointMake(self.newsBtn.center.x, self.userIView.height - 1);
}

- (void)readCollected {
    self.collectedScrollView.contentOffset = CGPointMake(kScreenWidth, 0);
    self.indicatorView.center = CGPointMake(self.readBtn.center.x, self.userIView.height - 1);
}

- (void)videoCollected {
    self.collectedScrollView.contentOffset = CGPointMake(kScreenWidth * 2, 0);
    self.indicatorView.center = CGPointMake(self.videoBtn.center.x, self.userIView.height - 1);
}

- (void)cleanClick {     //清除缓存
    //获取缓存大小
    NSInteger size = [[SDImageCache sharedImageCache] getSize] / 1024 / 1024;
    [[SDImageCache sharedImageCache] clearDisk];
    NSString *status = [NSString stringWithFormat:@"😎清理了%dM缓存", size];
    NSString *style = JDStatusBarStyleSuccess;
    [JDStatusBarNotification showWithStatus:status
                               dismissAfter:2.0
                                  styleName:style];
}

- (void)nightClick:(UISwitch *)nightSwitch {    //夜间模式
    switch (nightSwitch.on) {
        case YES: {
            [JDStatusBarNotification showWithStatus:@"✨开启夜间阅读"
                                       dismissAfter:2.0
                                          styleName:JDStatusBarStyleSuccess];
            self.nightView.hidden = NO;
            [SwitchSingleInstance defaultSwitchSingleInstance].isSwitch = YES;
        }
            break;
            
        default: {
            [JDStatusBarNotification showWithStatus:@"🔆关闭夜间阅读"
                                       dismissAfter:2.0
                                          styleName:JDStatusBarStyleDefault];
            self.nightView.hidden = YES;
            [SwitchSingleInstance defaultSwitchSingleInstance].isSwitch = NO;
        }
            break;
    }
}

- (void)replacePicClick {   //更换壁纸
    pickerTypt = PickerTyptBgPicture;
    UIImagePickerController *picker = [UIImagePickerController new];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)changeUserPhoto {   //点击头像触发的事件
    pickerTypt = PickerTyptUserPhoto;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"获取照片的位置" preferredStyle:UIAlertControllerStyleActionSheet];
    [self presentViewController:alertController animated:YES completion:nil];
    //照片库中获取的Action
    UIAlertAction *photoLibAction = [UIAlertAction actionWithTitle:@"照片库" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
    }];
    [alertController addAction:photoLibAction];
    //拍照获取的Action
    UIAlertAction *makePhotoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:nil];
        } else {
            [KVNProgress showErrorWithStatus:@"设备不支持相机拍照"];
        }
    }];
    //取消
    [alertController addAction:makePhotoAction];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
    }];
    [alertController addAction:cancel];
}

//选择照片UIImagePickerControllerDelegate的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *selectImage = [info objectForKey:UIImagePickerControllerEditedImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    switch (pickerTypt) {
        case PickerTyptUserPhoto:   //更换头像
        {
            self.userPhoto.image = selectImage;
            [UIImage saveImage:selectImage savePhotoName:@"userPhoto.jpg"];
        }
            break;
        case PickerTyptBgPicture:   //更换壁纸
        {
            self.bgImageView.image = selectImage;
            [UIImage saveImage:selectImage savePhotoName:@"bgPhoto.jpg"];
        }
        default:
            break;
    }
}

- (void)historyClick {  //最近浏览
    
}

//设置界面中的控件响应事件
- (void)setClick {
    self.setVC = [[SetViewController alloc] initWithNibName:@"SetViewController" bundle:nil];
    [self presentPopupViewController:self.setVC animationType:MJPopupViewAnimationSlideRightLeft];
    //清除缓存
    [self.setVC.cleanBtn addTarget:self action:@selector(cleanClick) forControlEvents:UIControlEventTouchUpInside];
    //夜间模式
    [self.setVC.nightSwitch addTarget:self action:@selector(nightClick:) forControlEvents:UIControlEventValueChanged];
    self.setVC.nightSwitch.on = [SwitchSingleInstance defaultSwitchSingleInstance].isSwitch;
    //更换壁纸
    [self.setVC.replacePic addTarget:self action:@selector(replacePicClick) forControlEvents:UIControlEventTouchUpInside];
    //最近浏览
    [self.setVC.history addTarget:self action:@selector(historyClick) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - UIScrollView Delegate


//滑动停止时改变指示视图位置
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int index = scrollView.contentOffset.x / scrollView.width;
    switch (index) {
        case 0:
            self.indicatorView.center = CGPointMake(self.newsBtn.center.x, self.userIView.height - 1);
            break;
        case 1:
            self.indicatorView.center = CGPointMake(self.readBtn.center.x, self.userIView.height - 1);
            break;
        case 2:
            self.indicatorView.center = CGPointMake(self.videoBtn.center.x, self.userIView.height - 1);
            break;
        default:
            break;
    }
}


#pragma mark - UITableView DataScore

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.allDataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.allDataArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerReuserIdentifier];
    if (section == 0) {
        headerView.textLabel.text = [NSString stringWithFormat:@"新闻收藏（%d条）", (int)self.newsDataArray.count];
    } else if (section == 1) {
        headerView.textLabel.text = [NSString stringWithFormat:@"多图收藏（%d条）", (int)self.photoDataArray.count];
    }
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuserIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.textColor = [UIColor colorWithRed:189 / 255.0 green:161 / 255.0 blue:69 / 255.0 alpha:1.0];
    cell.backgroundColor = [UIColor clearColor];
    if (indexPath.section == 0) {
        cell.textLabel.text = self.newsDataArray[indexPath.row][@"title"];
    } else {
        cell.textLabel.text = self.photoDataArray[indexPath.row][@"setname"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UIStoryboard *newsStroryboard = [UIStoryboard storyboardWithName:@"News" bundle:nil];
        SYDetailController *selfVC = [newsStroryboard instantiateViewControllerWithIdentifier:@"DetailVC"];
        NSDictionary *dic = self.newsDataArray[indexPath.row];
        SYNewsModel *model = [SYNewsModel new];
        [model setValuesForKeysWithDictionary:dic];
        selfVC.newsModel = model;
        [self.navigationController pushViewController:selfVC animated:YES];
    }
    else if (indexPath.section == 1) {
        UIStoryboard *newsStroryboard = [UIStoryboard storyboardWithName:@"News" bundle:nil];
        SYPhotoViewController *photoVC = [newsStroryboard instantiateViewControllerWithIdentifier:@"PhotoVC"];
        NSDictionary *dic = self.photoDataArray[indexPath.row];
        SYPhotoSet *model = [SYPhotoSet new];
        [model setValuesForKeysWithDictionary:dic];
        photoVC.photoSet = model;
        NSDictionary *modelDic = self.photoModelDataArray[indexPath.row];
        SYNewsModel *photoModel = [SYNewsModel new];
        [photoModel setValuesForKeysWithDictionary:modelDic];
        photoVC.newsModel = photoModel;
        [self.navigationController pushViewController:photoVC animated:YES];
    }
}

@end
