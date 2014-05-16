//
//  WPCheckList.h
//  WeatherPro
//
//  Created by liuhang on 14-5-12.
//  Copyright (c) 2014年 liuhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPCheckList : NSObject<NSCoding , NSCopying>

@property (strong, nonatomic) NSMutableArray *items;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *imageName;

-(int)countUncheckedItems;
@end
