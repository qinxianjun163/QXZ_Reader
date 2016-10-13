//
//  SetViewController.m
//  QZX_Reader
//
//  Created by zhangsiyao on 15/9/23.
//  Copyright © 2015年 ZhangSiYao. All rights reserved.
//

#import "SetViewController.h"

@interface SetViewController ()

@end

@implementation SetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [[UIColor blackColor]  colorWithAlphaComponent:0.9];
}
- (IBAction)talkWithUs:(id)sender {
    UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"我们的联系方式" message:@"🐧281016974\n🐧791085038\n🐧839229274\n" delegate:self cancelButtonTitle:@"知道哒" otherButtonTitles:nil, nil];
    [alerView show];
}
- (IBAction)outLine:(id)sender {
    UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录都没有哪来的退出登录" delegate:self cancelButtonTitle:@"知道哒" otherButtonTitles:nil, nil];
    [alerView show];
}

@end
