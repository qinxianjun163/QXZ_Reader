//
//  MovieTypeModel.h
//  QZX_Reader
//
//  Created by zhangsiyao on 15/9/26.
//  Copyright © 2015年 ZhangSiYao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MovieTypeModel : NSObject

@property (strong, nonatomic) NSString *bgPicture;  //背景图片
@property (strong, nonatomic) NSString *name;   //分类名称


- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
