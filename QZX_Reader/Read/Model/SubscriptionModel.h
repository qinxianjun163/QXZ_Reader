//
//  SubscriptionModel.h
//  ReaderThreeTest
//
//  Created by 肖冯敏 on 15/9/24.
//  Copyright (c) 2015年 o‘clock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SubscriptionModel : NSManagedObject

@property (nonatomic, retain) NSString * tid;
@property (nonatomic, retain) NSString * tname;
@property (nonatomic, retain) NSString * alias;
@property (nonatomic, retain) NSDate * subtime;

@end
