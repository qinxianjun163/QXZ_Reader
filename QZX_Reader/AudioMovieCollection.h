//
//  AudioMovieCollection.h
//  Eyes
//
//  Created by lanou3g on 15/9/21.
//  Copyright (c) 2015年 QXL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AudioMovieCollection : NSManagedObject

@property (nonatomic, retain) NSString * categoty;
@property (nonatomic, retain) NSString * coverBlurred;
@property (nonatomic, retain) NSString * coverForDetail;
@property (nonatomic, retain) NSNumber * date;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSString * myDescription;
@property (nonatomic, retain) NSString * playUrl;
@property (nonatomic, retain) NSString * title;

@end
