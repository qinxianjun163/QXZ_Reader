//
//  SetViewController.h
//  QZX_Reader
//
//  Created by zhangsiyao on 15/9/23.
//  Copyright © 2015年 ZhangSiYao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *cleanBtn;  //清除缓存按钮

@property (strong, nonatomic) IBOutlet UISwitch *nightSwitch;   //夜间模式Switch

@property (strong, nonatomic) IBOutlet UIButton *replacePic;    //更换壁纸

@property (strong, nonatomic) IBOutlet UIButton *history;   //最近浏览

@end
