//
//  UIImage+SYArchver.m
//  QZX_Reader
//
//  Created by zhangsiyao on 15/9/25.
//  Copyright © 2015年 ZhangSiYao. All rights reserved.
//

#import "UIImage+SYArchver.h"

@implementation UIImage (SYArchver)

+ (void)saveImage:(UIImage *)image savePhotoName:(NSString *)photoName {
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(9, 1, 1) lastObject];
    NSString *photoPath = [docPath stringByAppendingPathComponent:photoName];
    [NSKeyedArchiver archiveRootObject:image toFile:photoPath];
}

+ (UIImage *)getImageWithSavePhotoName:(NSString *)photoName {
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(9, 1, 1) lastObject];
    NSString *photoPath = [docPath stringByAppendingPathComponent:photoName];
    UIImage *image = [NSKeyedUnarchiver unarchiveObjectWithFile:photoPath];
    if (image == nil) {
        if ([photoName isEqualToString:@"bgPhoto.jpg"]) {
            return [UIImage imageNamed:@"bgImage"];
        } else {
            return [UIImage imageNamed:@"userPhoto"];
        }
    }
    return image;
}

@end
