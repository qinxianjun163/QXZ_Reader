//
//  SubscriptionReader.h
//  ReaderThreeTest
//
//  Created by 肖冯敏 on 15/9/24.
//  Copyright (c) 2015年 o‘clock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SubscriptionModel.h"
#import "ReadListModel.h"
#import <CoreData/CoreData.h>

@interface SubscriptionReader : NSObject

+ (void)creatSubscriptionWithContext:(NSManagedObjectContext *)context;

+ (BOOL)addSubscriptionByModel:(ReadListModel *)model WithContext:(NSManagedObjectContext *)context;

+ (BOOL)deleteSubscriptionByModel:(ReadListModel *)model WithContext:(NSManagedObjectContext *)context;//返回一个BOOL判断是否删除成功

+ (NSArray *)selectAllSubscriptionWithContext:(NSManagedObjectContext *)context;

//返回特定的coredata 用于判断是否已经订阅
//+ (ReadListModel *)selectSubscriptionCoreDataBy:(NSString *)tid WithContext:(NSManagedObjectContext *)context;
//+ (BOOL)isSubscriptionCoreDataBy:(NSString *)tid WithContext:(NSManagedObjectContext *)context;

//返回特定的coredata 用于判断是否已经订阅
+ (BOOL)isExist:(NSString *)tid WithContext:(NSManagedObjectContext *)context;

@end
