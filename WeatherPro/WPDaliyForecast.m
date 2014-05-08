//
//  WPDaliyForecast.m
//  WeatherPro
//
//  Created by liuhang on 14-5-5.
//  Copyright (c) 2014年 liuhang. All rights reserved.
//

#import "WPDaliyForecast.h"

@implementation WPDaliyForecast

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSMutableDictionary *paths = [[super JSONKeyPathsByPropertyKey] mutableCopy];
    
    paths[@"tempHigh"] = @"temp.max";
    paths[@"tempLow"] = @"temp.min";
    
    return paths;
}

@end
