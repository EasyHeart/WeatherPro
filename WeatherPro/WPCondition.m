//
//  WPCondition.m
//  WeatherPro
//
//  Created by liuhang on 14-5-5.
//  Copyright (c) 2014年 liuhang. All rights reserved.
//

#import "WPCondition.h"
#define MPS_TO_MPH 2.23694f

@implementation WPCondition

+ (NSDictionary *)imageMap
{
    static NSDictionary *_imageMap = nil;
    if (!_imageMap) {
        _imageMap = @{
                      @"01d" : @"weather-clear",
                      @"02d" : @"weather-few",
                      @"03d" : @"weather-few",
                      @"04d" : @"weather-broken",
                      @"09d" : @"weather-shower",
                      @"10d" : @"weather-rain",
                      @"11d" : @"weather-tstorm",
                      @"13d" : @"weather-snow",
                      @"50d" : @"weather-mist",
                      @"01n" : @"weather-moon",
                      @"02n" : @"weather-few-night",
                      @"03n" : @"weather-few-night",
                      @"04n" : @"weather-broken",
                      @"09n" : @"weather-shower",
                      @"10n" : @"weather-rain-night",
                      @"11n" : @"weather-tstorm",
                      @"13n" : @"weather-snow",
                      @"50n" : @"weather-mist",
                     };
    }
    return _imageMap;
}

- (NSString *)imageName
{
    return [WPCondition imageMap][self.icon];
}

+ (NSDictionary *) JSONKeyPathsByPropertyKey
{
    return @{
             @"date": @"dt",
             @"locationName": @"name",
             @"humidity": @"main.humidity",
             @"temperature": @"main.temp",
             @"tempHigh": @"main.temp_max",
             @"tempLow": @"main.temp_min",
             @"sunrise": @"sys.sunrise",
             @"sunset": @"sys.sunset",
             @"conditionDescription": @"weather.description",
             @"condition": @"weather.main",
             @"icon": @"weather.icon",
             @"windBearing": @"wind.deg",
             @"windSpeed": @"wind.speed",
             };     //key是WXConditon的属性名称,value是JSON的路径
}
// Unit事件类的NSInteger值 和 NSdate类型的值 之间的相互转化方法
+ (NSValueTransformer *)dateJSONTransformer
{
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [NSDate dateWithTimeIntervalSince1970:str.floatValue];
    }
                                                         reverseBlock:^(NSDate *date){
                                                             return [NSString stringWithFormat:@"%f",[date timeIntervalSince1970]];
                                                         }];
}

+ (NSValueTransformer *)sunriseJSONTransformer
{
    return [self dateJSONTransformer];
}

+ (NSValueTransformer *)sunsetJSONTransformer
{
    return [self dateJSONTransformer];
}

//NSArray 和 NSString 的之间的转换
+ (NSValueTransformer *) conditionDescriptionJSONTransformer
{
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSArray *values){
        return [values firstObject];
    }reverseBlock:^(NSString *str) {
        return @[str];
    }];
}

+ (NSValueTransformer *)conditionJSONTransformer
{
    return [self conditionDescriptionJSONTransformer];
}

+ (NSValueTransformer *)iconJSONTransformer
{
    return [self conditionDescriptionJSONTransformer];
}

//OpenWeather API使用每秒/米的风速
+ (NSValueTransformer *)windSpeedJSONTransformer
{
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSNumber *num){
        return @(num.floatValue*MPS_TO_MPH);
    }reverseBlock:^(NSNumber *speed){
        return @(speed.floatValue/MPS_TO_MPH);
    }];
}
/*
+ (NSValueTransformer *)temperatureJSONTransformer
{
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSNumber *num) {
        return @((num.floatValue-32)*5/9);
    }reverseBlock:^(NSNumber *temp){
        return @((9/5*temp.floatValue)+32);
    }];
}

 + (NSValueTransformer *)tempHighJSONTransformer
{
    return [self temperatureJSONTransformer];
}

+ (NSValueTransformer *)tempLowJSONTransformer
{
    return [self temperatureJSONTransformer];
} */
@end
