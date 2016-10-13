//
//  MyWebView.h
//  UIWebViewTWHB
//
//  Created by 肖冯敏 on 15/10/4.
//  Copyright (c) 2015年 o‘clock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewModel.h"
#import "ReadDetailModel.h"

@protocol MyWebViewDelegate <NSObject>

- (void)collection;

@end

@interface MyWebView : UIWebView

@property (nonatomic, strong) WebViewModel *webModel;
@property (nonatomic, strong) NSDictionary *dic;
@property (nonatomic, strong) UIButton *collectButton;
@property (nonatomic, strong) ReadDetailModel *model;
@property (nonatomic, assign) id <MyWebViewDelegate> delegate_;

- (void)loadMyWebView;

@end
