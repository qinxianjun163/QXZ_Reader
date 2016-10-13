//
//  SubscriptionReader.m
//  ReaderThreeTest
//
//  Created by 肖冯敏 on 15/9/24.
//  Copyright (c) 2015年 o‘clock. All rights reserved.
//

#import "SubscriptionReader.h"

@implementation SubscriptionReader

+ (void)creatSubscriptionWithContext:(NSManagedObjectContext *)context {
    NSManagedObjectModel *modle = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:modle];
    
    //URL是让我们提供一个保存的地址和取值的地址
    NSString *doc = [NSSearchPathForDirectoriesInDomains(9, 1, 1) lastObject];//取得沙盒地址
    
    NSString *sqlPath = [doc stringByAppendingPathComponent:@"SubscriptionCoreData.sqlite"];//在沙盒路径下创建文件
    [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:sqlPath] options:nil error:nil];
    //store属性设置完成后 赋值给content
    context.persistentStoreCoordinator = store;
}

//添加 收藏.
+ (BOOL)addSubscriptionByModel:(ReadListModel *)model WithContext:(NSManagedObjectContext *)context {
    //注意Name 要用 类的名字
    SubscriptionModel *saveModel = [NSEntityDescription insertNewObjectForEntityForName:@"SubscriptionModel" inManagedObjectContext:context];
    if ([SubscriptionReader isExist:model.tid WithContext:context]) {
        return NO;
    }
    saveModel.tid = model.tid;
    saveModel.tname = model.tname;
    saveModel.alias = model.alias;
    saveModel.subtime = [NSDate dateWithTimeIntervalSince1970:[[NSDate date] timeIntervalSince1970]];
    [context save:nil];
    return YES;
}

//返回一个BOOL判断是否删除成功
+ (BOOL)deleteSubscriptionByModel:(ReadListModel *)model WithContext:(NSManagedObjectContext *)context{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SubscriptionModel"];
    NSArray *array = [context executeFetchRequest:request error:nil];
    
    for (SubscriptionModel *deleteModel in array) {
        if ([deleteModel.tid isEqualToString:model.tid ]) {
            [context deleteObject:deleteModel];
            [context save:nil];
            return YES;
        }
    }
    [context save:nil];
    return NO;
}


+ (NSArray *)selectAllSubscriptionWithContext:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SubscriptionModel"];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"tid" ascending:YES];
    request.sortDescriptors = @[sort];
    
    NSArray *array = [context executeFetchRequest:request error:nil];

    return array;
}

//返回特定的coredata 用于判断是否已经订阅
//+ (SubscriptionModel *)selectSectionCoreDataBy:(NSString *)tid WithContext:(NSManagedObjectContext *)context {
//    
//}


//返回特定的coredata 用于判断是否已经订阅
+ (BOOL)isExist:(NSString *)tid WithContext:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SubscriptionModel"];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"tid" ascending:YES];
    request.sortDescriptors = @[sort];
    
    NSArray *array = [context executeFetchRequest:request error:nil];
    for (SubscriptionModel *model in array) {
        if ([model.tid isEqualToString:tid]) {
            return YES;
        }
    }
    return NO;
}

@end
