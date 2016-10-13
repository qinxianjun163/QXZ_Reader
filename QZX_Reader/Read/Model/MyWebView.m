//
//  MyWebView.m
//  UIWebViewTWHB
//
//  Created by 肖冯敏 on 15/10/4.
//  Copyright (c) 2015年 o‘clock. All rights reserved.
//

#import "MyWebView.h"
#import "LayoutMacro.h"

@implementation MyWebView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.collectButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.collectButton.frame = CGRectMake(0, 0, 50, 30);
        [self.collectButton setTitle:@"收藏" forState:UIControlStateNormal];
        [self.collectButton setTitle:@"已收藏" forState:UIControlStateSelected];
        [self.collectButton addTarget:self action:@selector(collection:) forControlEvents:UIControlEventTouchUpInside];
        self.opaque = NO;
    }
    return self;
}

- (void)collection:(UIButton *)button {
    if ([self.delegate_ respondsToSelector:@selector(collection)]) {
        [self.delegate_ collection];
    }
}

- (void)loadMyWebView {
    self.webModel = [[WebViewModel alloc] initWithDictionary:self.dic];
    NSString *str = self.webModel.body;
    for (int i = 0; i < [self.webModel.img count]; i++) {
        str = [self filterHTML:str num:i webViewModel:self.webModel];
    }
    //最后一步, 读取MyWebView
    [self loadHTMLString:str baseURL:nil];
}

- (NSString *)filterHTML:(NSString *)html num:(int)num webViewModel:(WebViewModel *)model
{
    NSArray *bodyArray = [html componentsSeparatedByString:[NSString stringWithFormat:@"<!--IMG#%d-->", num]];
    NSArray *pixArray = [[model.img[num] objectForKey:@"pixel"] componentsSeparatedByString:@"*"];
    
    int height = (kScreenWidth - 15) /[pixArray[0] intValue] * [pixArray[1] intValue];
    
    NSMutableString *totalStr = [NSMutableString string];
    NSString *onload = @"this.onclick = function() {"
    "  window.location.href = 'sx:src=' +this.src;"
    "};";
    NSString *str = [NSString stringWithFormat:@"<img onload=\"%@\" src=%@  height=%d width=%d />", onload, [model.img[num] objectForKey:@"src"], height, (int)kScreenWidth - 15];
    [totalStr appendFormat:@"%@%@%@", bodyArray[0], str, bodyArray[1]];
    return totalStr;
}

@end
