//
//  SYReplyCell.m
//  QZX_Reader
//
//  Created by zhangsiyao on 15/9/22.
//  Copyright © 2015年 ZhangSiYao. All rights reserved.
//

#import "SYReplyCell.h"

@interface SYReplyCell ()

/** 用户名称 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/** 用户ip信息 */
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
/** 用户的点赞数 */
@property (weak, nonatomic) IBOutlet UILabel *supposeLabel;

@end

@implementation SYReplyCell

/** set方法数据分发 */
- (void)setReplyModel:(SYReplyModel *)replyModel {
    _replyModel = replyModel;
    if (replyModel.name == nil) {
        replyModel.name = @"";
    }
    self.nameLabel.text = replyModel.name;
    self.addressLabel.text = replyModel.address;
    
    NSRange rangeAddress = [replyModel.address rangeOfString:@"&nbsp"];
    if (rangeAddress.location != NSNotFound) {
        self.addressLabel.text = [replyModel.address substringToIndex:rangeAddress.location];
    }
    self.sayLabel.text = replyModel.say;
    
    NSRange rangeSay = [replyModel.say rangeOfString:@"<br>"];
    if (rangeSay.location != NSNotFound) {
        NSMutableString *tempSay = [replyModel.say mutableCopy];
        [tempSay replaceOccurrencesOfString:@"<br>" withString:@"\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, tempSay.length)];
        self.sayLabel.text = tempSay;
    }
    self.supposeLabel.text = replyModel.suppose;
}

@end
