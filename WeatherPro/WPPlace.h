//
//  BIDPlace.h
//  Where ame I
//
//  Created by liuhang on 14-4-28.
//  Copyright (c) 2014年 liuhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface WPPlace : NSObject <MKAnnotation>

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *subtitle;
@property (assign, nonatomic) CLLocationCoordinate2D coordinate;

@end
