//
//  ReaderHeaderItemView.h
//  ReaderThreeTest
//
//  Created by 肖冯敏 on 15/9/24.
//  Copyright (c) 2015年 o‘clock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReaderItemView.h"

@interface ReaderHeaderItemView : UIView

@property (nonatomic, strong) ReaderItemView *showAllItemView;

@property (nonatomic, strong) ReaderItemView *refreshItemView;

@property (nonatomic, strong) ReaderItemView *subscriptionItemView;

@end
