//
//  ReadDetailModel.h
//  ReaderThreeTest
//
//  Created by 肖冯敏 on 15/9/16.
//  Copyright (c) 2015年 o‘clock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReadDetailModel : UIScrollView

@property (strong, nonatomic) NSString *digest;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *docid;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *source;
@property (strong, nonatomic) NSString *lmodify; //时间戳
@property (strong, nonatomic) NSString *imgsrc;
@property (strong, nonatomic) NSString *ptime;
@property (strong, nonatomic) NSString *pixel;
@property (assign, nonatomic) BOOL isCollected; //是否收藏.


//装逼方法，一行代码 KVC
- (instancetype)initWithDictionary:(NSDictionary *)dic;
/*
 "url_3w":"",
 "votecount":1,
 "replyCount":4,
 "pixel":"500*625",
 "digest":"感受来自喵星人的愤怒吧！国外玩家自制伊利喵。这么有杀气的喵星人我还是第一次见！回家一定好好打扮我家的喵！阅读",
 "url":"http://mp.weixin.qq.com/s?__biz=MjM5MDAzOTc5OQ==&mid=208486036&idx=2&sn=cec2ff41c776c0eb797de08b0eb26e42&scene=4#wechat_redirect",
 "docid":"B3ISIQRA052686DJ",
 "title":"感受来自喵星人的愤怒吧！",
 "source":"暴雪娱乐",
 "priority":60,
 "lmodify":"2015-09-15 18:28:13",
 "subtitle":"",
 "boardid":"dy_wemedia_bbs",
 "imgsrc":"http://imgm.ph.126.net/SwZ-pI-nxiE5TOFGacfCBA==/6631374529443721189.jpg",
 "ptime":"2015-09-15 18:18:24"
 */
@end
