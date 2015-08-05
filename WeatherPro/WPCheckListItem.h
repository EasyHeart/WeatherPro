//
//  WPCheckListItem.h
//  WeatherPro
//
//  Created by liuhang on 14-5-10.
//  Copyright (c) 2014年 liuhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPCheckListItem : NSObject<NSCoding>

@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) BOOL checked;


@property(nonatomic,copy)NSDate *dueDate;
@property(nonatomic,assign) BOOL shouldRemind;
@property (nonatomic, assign) NSInteger itemID;


-(void)scheduleNotification;

-(void)toggleChecked;
@end
