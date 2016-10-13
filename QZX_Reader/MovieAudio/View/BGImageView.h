//
//  BGImageView.h
//  QZX_Reader
//
//  Created by zhangsiyao on 15/10/3.
//  Copyright © 2015年 ZhangSiYao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BGImageView : UIScrollView

//定义一个定时器 自己放大缩小,销毁本程序的时候  需要调用 [self.timer invalodate];此视图才会被销毁掉
@property (strong, nonatomic) NSTimer *timer;

@property (strong, nonatomic) NSString *url;//图片地址

@end
