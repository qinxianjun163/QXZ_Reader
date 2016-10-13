//
//  CollectionReader.h
//  ReaderThreeTest
//
//  Created by 肖冯敏 on 15/9/26.
//  Copyright (c) 2015年 o‘clock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CollectionModel.h"
#import <CoreData/CoreData.h>
#import "ReadDetailModel.h"

@interface CollectionReader : NSObject

+ (void)creatCollectionWithContext:(NSManagedObjectContext *)context;

+ (BOOL)addCollectionByModel:(ReadDetailModel *)model WithContext:(NSManagedObjectContext *)context;

+ (BOOL)deleteCollectionByModel:(ReadDetailModel *)model WithContext:(NSManagedObjectContext *)context;//返回一个BOOL判断是否删除成功

+ (NSArray *)selectAllCollectionWithContext:(NSManagedObjectContext *)context;

//返回特定的coredata 用于判断是否已经订阅
+ (BOOL)isExist:(NSString *)title WithContext:(NSManagedObjectContext *)context;

@end
