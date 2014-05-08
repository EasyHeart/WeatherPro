//
//  WPManager.m
//  WeatherPro
//
//  Created by liuhang on 14-5-5.
//  Copyright (c) 2014年 liuhang. All rights reserved.
//

#import "WPManager.h"
#import "WPClient.h"
#import <TSMessages/TSMessage.h>

@interface WPManager ()

@property (nonatomic, strong, readwrite) WPCondition *currentCondition;
@property (nonatomic, strong, readwrite) CLLocation *currentLocation;
@property (nonatomic, strong, readwrite) NSArray *hourlyForecast;
@property (nonatomic, strong, readwrite) NSArray *dailyForecast;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) BOOL isFirstUpdate;
@property (nonatomic, strong) WPClient *client;
@end


@implementation WPManager

+ (instancetype)sharedManager   //单例构造器
{
    static id _sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc]init];
    });
    
    return _sharedManager;
}

- (id)init
{
    if (self = [super init]) {
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate =self;
        _client = [[WPClient alloc]init];  //为管理器创建WPClient对象,处理所有的网络请求与数据解析
        [[[[RACObserve(self, currentLocation)    //利用ReactiveCocoa脚本来观察自身的currentLocation
            ignore:nil]  //为了继续执行方法链,忽略空值
           flattenMap:^(CLLocation *newLocation) {   //映射数据,返回一个包含三个信号的对象
               return [RACSignal merge:@[
                                         [self updateCurrentConditions],
                                         [self updateDailyForecast],
                                         [self updateHourlyForecast]
                                         ]];
           }] deliverOn:RACScheduler.mainThreadScheduler]  //将信号传递给主线程上的观察者
         //错误显示
         subscribeError:^(NSError *error) {
             [TSMessage showNotificationWithTitle:@"Error" subtitle:@"There was a problem fetching the lastest weather." type:TSMessageNotificationTypeError];
         }];

    
    }
    return self;
}

- (void)findCurrentLocation
{
    self.isFirstUpdate = YES;
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //忽略第一个位置更新,因为它一般是缓冲值
    if (self.isFirstUpdate) {
        self.isFirstUpdate = NO;
        return;
    }
    CLLocation *location = [locations lastObject];
    //一旦获得足够精度的位置,停止进一步的更新
    if (location.horizontalAccuracy > 0) {
        //更新currentLocaton,这将触发init中设置的RACObservable
        self.currentLocation = location;
        [self.locationManager stopUpdatingLocation];
        //NSLog(@"%@",self.currentLocation);
    }
}

- (RACSignal *)updateCurrentConditions {
    return [[self.client fetchCurrentConditionsForLocation:self.currentLocation.coordinate] doNext:^(WPCondition *condition) {
        self.currentCondition = condition;
        NSLog(@"%@",self.currentCondition);
    }];
}

- (RACSignal *)updateHourlyForecast {
    return [[self.client fetchHourlyForecastForLoaction:self.currentLocation.coordinate] doNext:^(NSArray *conditions){
        self.hourlyForecast = conditions;
        //NSLog(@"%@",self.hourlyForecast);
    }];
}

- (RACSignal *)updateDailyForecast {
    return [[self.client fetchDailyForecastForLocation:self.currentLocation.coordinate] doNext:^(NSArray *conditions) {
        self.dailyForecast = conditions;
        //NSLog(@"%@",self.dailyForecast);
    }];
}



@end
