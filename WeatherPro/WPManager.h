//
//  WPManager.h
//  WeatherPro
//
//  Created by liuhang on 14-5-5.
//  Copyright (c) 2014年 liuhang. All rights reserved.
//

@import Foundation;
@import CoreLocation;
#import <ReactiveCocoa/ReactiveCocoa/ReactiveCocoa.h>
#import "WPCondition.h"

@interface WPManager : NSObject <CLLocationManagerDelegate>

+ (instancetype)sharedManager;

@property (nonatomic, strong, readonly) CLLocation *currentLocation;
@property (nonatomic, strong, readonly) WPCondition *currentCondition;  //致命错误!!!!!将公开属性中的currentCondition写成了
@property (nonatomic, strong, readonly) NSArray *hourlyForecast;       //currentConditon,导致无法从私有方法中赋值,因为这个值根本
@property (nonatomic, strong, readonly) NSArray *dailyForecast;       //不存在!!!!

- (void)findCurrentLocation;

@end
