//
//  DetailView.h
//  QZX_Reader
//
//  Created by zhangsiyao on 15/10/3.
//  Copyright © 2015年 ZhangSiYao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoaryModel.h"
#import "DIYButton.h"


@protocol DetailViewDelegate <NSObject>

- (void)playMovie:(CategoaryModel *)model;
- (void)share;

@end

@interface DetailView : UIView

@property (strong, nonatomic) CategoaryModel *model;

@property (assign, nonatomic) id<DetailViewDelegate>delegate;

@end
