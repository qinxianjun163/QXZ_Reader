//
//  WebViewModel.h
//  UIWebViewTWHB
//
//  Created by 肖冯敏 on 15/10/4.
//  Copyright (c) 2015年 o‘clock. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebViewModel : NSObject

@property (nonatomic, strong) NSString *body;
@property (nonatomic, strong) NSArray *users;
@property (nonatomic, assign) NSInteger replyCount;
@property (nonatomic, strong) NSArray *ydbaike;
@property (nonatomic, strong) NSString *source_url;
@property (nonatomic, strong) NSArray *link;
@property (nonatomic, strong) NSArray *votes;
@property (nonatomic, strong) NSArray *img;
@property (nonatomic, strong) NSString *digest;
@property (nonatomic, strong) NSArray *topiclist_news;
@property (nonatomic, strong) NSString *dkeys;
@property (nonatomic, strong) NSArray *topiclist;
@property (nonatomic, strong) NSString *docid;
@property (nonatomic, strong) NSDictionary *sourceinfo;
@property (nonatomic, assign) BOOL picnews;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *tid;
@property (nonatomic, strong) NSString *templateR;
@property (nonatomic, assign) NSInteger threadVote;
@property (nonatomic, assign) NSInteger threadAgainst;
@property (nonatomic, strong) NSArray *boboList;
@property (nonatomic, strong) NSString *replyBoard;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, assign) BOOL hasNext;
@property (nonatomic, strong) NSString *voicecomment;
@property (nonatomic, strong) NSArray *relative_sys;
@property (nonatomic, strong) NSArray *apps;
@property (nonatomic, strong) NSString *ptime;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
