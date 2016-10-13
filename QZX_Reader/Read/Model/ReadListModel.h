//
//  ReadListModel.h
//  ReaderThreeTest
//
//  Created by 肖冯敏 on 15/9/22.
//  Copyright (c) 2015年 o‘clock. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReadListModel : NSObject

@property (strong, nonatomic) NSString *alias;
@property (strong, nonatomic) NSString *cid;
@property (strong, nonatomic) NSString *color;
@property (strong, nonatomic) NSString *ename;
@property (strong, nonatomic) NSString *showType;
@property (strong, nonatomic) NSString *subnum;
@property (strong, nonatomic) NSString *tid;
@property (strong, nonatomic) NSString *tname;
@property (strong, nonatomic) NSString *topicid;
@property (assign, nonatomic) BOOL isSubscription;  //是否订阅 用于创建的时候进行 判断


- (instancetype)initWithDictionary:(NSDictionary *)dic;


@end
