//
//  ReadHeaderView.h
//  ReaderThreeTest
//
//  Created by 肖冯敏 on 15/9/15.
//  Copyright (c) 2015年 o‘clock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReadListModel.h"

@protocol ReadHeaderViewDelegate <NSObject>

//下载完成后执行的代理方法。主要作用：让单例移除下载完成后的对象.
//- (void)didFinishDownloadWithURL:(NSString *)url;
- (void)subscription:(UIButton *)button;

@end

@interface ReadHeaderView : UIView

@property (nonatomic, strong) NSString *tid;
@property (nonatomic, strong) NSString *tname;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *describeLabel;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UILabel *subnumLabel; //订阅数
@property (nonatomic, strong) UIButton *backButton;  //返回按钮
@property (nonatomic, strong) UIButton *subscriptionButton; //订阅按钮

@property (nonatomic, assign) id<ReadHeaderViewDelegate> delegate;

- (void)updateHeaderView;
- (UIColor *)createImageView;

@end
