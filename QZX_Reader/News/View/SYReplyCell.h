//
//  SYReplyCell.h
//  QZX_Reader
//
//  Created by zhangsiyao on 15/9/22.
//  Copyright © 2015年 ZhangSiYao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYReplyModel.h"

@interface SYReplyCell : UITableViewCell

@property(strong, nonatomic) SYReplyModel *replyModel;
/** 用户的发言 */
@property (weak, nonatomic) IBOutlet UILabel *sayLabel;

@end
