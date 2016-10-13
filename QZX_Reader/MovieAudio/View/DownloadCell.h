//
//  DownloadCell.h
//  QZX_Reader
//
//  Created by zhangsiyao on 15/10/4.
//  Copyright © 2015年 ZhangSiYao. All rights reserved.
//

#import "CategoaryViewCell.h"

typedef void(^DownloadComplated)(NSIndexPath *indePath);
typedef void(^DeleteDownload)(NSIndexPath *indexPath);

@interface DownloadCell : CategoaryViewCell

@property (strong, nonatomic) NSIndexPath *indexPath;

// 下载完成的block方法和删除的block
- (void)downloadComplated:(DownloadComplated)complated delete:(DeleteDownload)deleteDownload;

@end
