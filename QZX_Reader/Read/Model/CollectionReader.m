//
//  CollectionReader.m
//  ReaderThreeTest
//
//  Created by 肖冯敏 on 15/9/26.
//  Copyright (c) 2015年 o‘clock. All rights reserved.
//

#import "CollectionReader.h"

@implementation CollectionReader

+ (void)creatCollectionWithContext:(NSManagedObjectContext *)context {
    NSManagedObjectModel *modle = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:modle];
    
    //URL是让我们提供一个保存的地址和取值的地址
    NSString *doc = [NSSearchPathForDirectoriesInDomains(9, 1, 1) lastObject];//取得沙盒地址
    
    NSString *sqlPath = [doc stringByAppendingPathComponent:@"CollectionCoreData.sqlite"];//在沙盒路径下创建文件
    [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:sqlPath] options:nil error:nil];
    //store属性设置完成后 赋值给content
    context.persistentStoreCoordinator = store;
}

+ (BOOL)addCollectionByModel:(ReadDetailModel *)model WithContext:(NSManagedObjectContext *)context {
    //注意Name 要用 类的名字
    CollectionModel *saveModel = [NSEntityDescription insertNewObjectForEntityForName:@"CollectionModel" inManagedObjectContext:context];
    if ([CollectionReader isExist:model.title WithContext:context]) {
        return NO;
    }
    saveModel.digest = model.digest;
    saveModel.url = model.url;
    saveModel.docid = model.docid;
    saveModel.title = model.title;
    saveModel.source = model.source;
    saveModel.lmodify = model.lmodify;
    saveModel.imgsrc = model.imgsrc;
    saveModel.ptime = model.ptime;
    saveModel.pixel = model.pixel;
    [context save:nil];
    return YES;
}

+ (BOOL)deleteCollectionByModel:(ReadDetailModel *)model WithContext:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CollectionModel"];
    NSArray *array = [context executeFetchRequest:request error:nil];

    for (CollectionModel *deleteModel in array) {
        if ([deleteModel.title isEqualToString:model.title ]) {
            [context deleteObject:deleteModel];
            [context save:nil];
            return YES;
        }
    }
    [context save:nil];
    return NO;
}//返回一个BOOL判断是否删除成功

+ (NSArray *)selectAllCollectionWithContext:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CollectionModel"];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"ptime" ascending:YES];
    request.sortDescriptors = @[sort];
    NSArray *array = [context executeFetchRequest:request error:nil];
    return array;
}

//返回特定的coredata 用于判断是否已经订阅
+ (BOOL)isExist:(NSString *)title WithContext:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CollectionModel"];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"ptime" ascending:YES];
    request.sortDescriptors = @[sort];
    
    NSArray *array = [context executeFetchRequest:request error:nil];
    for (CollectionModel *model in array) {
        if ([model.title isEqualToString:title]) {
            return YES;
        }
    }
    return NO;
}

@end
