//
//  UIImage+SYArchver.h
//  QZX_Reader
//
//  Created by zhangsiyao on 15/9/25.
//  Copyright © 2015年 ZhangSiYao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SYArchver)

+ (void)saveImage:(UIImage *)image savePhotoName:(NSString *)photoName;

+ (UIImage *)getImageWithSavePhotoName:(NSString *)photoName;

@end
