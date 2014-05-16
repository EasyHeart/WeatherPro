//
//  WPAllListDataModel.h
//  WeatherPro
//
//  Created by liuhang on 14-5-13.
//  Copyright (c) 2014年 liuhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPAllListDataModel : NSObject

@property(nonatomic,strong)NSMutableArray *lists;

-(void)saveChecklists;

-(void)sortChecklists;

+ (NSInteger)nextCheckListItemID;

@end
