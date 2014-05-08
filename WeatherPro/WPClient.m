//
//  WPClient.m
//  WeatherPro
//
//  Created by liuhang on 14-5-5.
//  Copyright (c) 2014年 liuhang. All rights reserved.
//

#import "WPClient.h"
#import "WPCondition.h"
#import "WPDaliyForecast.h"

@interface WPClient()

@property (nonatomic, strong) NSURLSession *session;  //管理API请求的URL session

@end

@implementation WPClient

-(id)init
{
    if (self = [super init]) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config];
    }
    return self;
}

- (RACSignal *)fetchJSONFromURL:(NSURL *)url
{
    NSLog(@"Fetching : %@",url.absoluteString);
    
    //返回信号. 不会被执行直到这个信号被订阅
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber){
        //创建一个NSURLSessionDataTask从URL中获取数据
        NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            //retrieved data
            if (!error) {
                NSError *jsonError = nil;
                id json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
                if (!jsonError) {
                    //当JSON数据存在并且没有错误时,发送给订阅者序列化后的JSON数组或字典
                    [subscriber sendNext:json];
                   // NSLog(@"%@",json);
                }
                else {
                    //如果有错误,通知订阅者
                    [subscriber sendError:jsonError];
                }
            }
            else {
                //有错误时,通知订阅者
                [subscriber sendError:error];
            }
            //无论该请求成功还是失败,通知订阅者请求已经完成
            [subscriber sendCompleted];
        }];
        //一旦信号被订阅,启动网络请求
        [dataTask resume];
        //负责信号被销毁后的清理工作
        return [RACDisposable disposableWithBlock:^{
            [dataTask cancel];
        }];
    }]      //记录发生的错误
            doError:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

//获取当前状况
- (RACSignal *)fetchCurrentConditionsForLocation:(CLLocationCoordinate2D)coordinate
{
    NSString *urlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&units=imperial",coordinate.latitude,coordinate.longitude];
    NSURL *url = [NSURL URLWithString:urlString];
    
    return [[self fetchJSONFromURL:url] map:^(NSDictionary *json) {
        return [MTLJSONAdapter modelOfClass:[WPCondition class] fromJSONDictionary:json error:nil];
        }];
}

//获取每小时预报
- (RACSignal *)fetchHourlyForecastForLoaction:(CLLocationCoordinate2D)coordinate
{

    NSString *urlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast?lat=%f&lon=%f&units=imperial&cnt=12",coordinate.latitude, coordinate.longitude];
    NSURL *url = [NSURL URLWithString:urlString];
    
    return [[self fetchJSONFromURL:url]map:^(NSDictionary *json){
        RACSequence *list = [json[@"list"] rac_sequence];
        
        return [[list map:^(NSDictionary *item) {
            return [MTLJSONAdapter modelOfClass:[WPCondition class] fromJSONDictionary:item error:nil];
        }] array];
    }];
}

//获取每日预报
- (RACSignal *)fetchDailyForecastForLocation:(CLLocationCoordinate2D)coordinate
{
    NSString *urlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/daily?lat=%f&lon=%f&units=imperial&cnt=7",coordinate.latitude, coordinate.longitude];
    NSURL *url = [NSURL URLWithString:urlString];
    
    return [[self fetchJSONFromURL:url]map:^(NSDictionary *json) {
        RACSequence *list = [json[@"list"] rac_sequence];
        
        return [[list map:^(NSDictionary *item) {
            return [MTLJSONAdapter modelOfClass:[WPDaliyForecast class] fromJSONDictionary:item error:nil];
        }]array];
    }];
}

@end
