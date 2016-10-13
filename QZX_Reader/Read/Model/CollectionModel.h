//
//  CollectionModel.h
//  ReaderThreeTest
//
//  Created by 肖冯敏 on 15/9/26.
//  Copyright (c) 2015年 o‘clock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CollectionModel : NSManagedObject

@property (nonatomic, retain) NSString * pixel;
@property (nonatomic, retain) NSString * ptime;
@property (nonatomic, retain) NSString * imgsrc;
@property (nonatomic, retain) NSString * lmodify;
@property (nonatomic, retain) NSString * source;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * docid;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * digest;

@end
