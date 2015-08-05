//
//  WPCheckListItem.m
//  WeatherPro
//
//  Created by liuhang on 14-5-10.
//  Copyright (c) 2014年 liuhang. All rights reserved.
//

#import "WPCheckListItem.h"
#import "WPAllListDataModel.h"

@implementation WPCheckListItem

- (void)toggleChecked
{
    self.checked = !self.checked;
}

-(id)init{
    
    if((self =[super init])){
        self.itemID = [WPAllListDataModel nextCheckListItemID];
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super init])) {
        self.text = [aDecoder decodeObjectForKey:@"Text"];
        self.checked = [aDecoder decodeBoolForKey:@"Checked"];
        self.dueDate = [aDecoder decodeObjectForKey:@"DueDate"];
        self.shouldRemind = [aDecoder decodeBoolForKey:@"ShouldRemind"];
        self.itemID = [aDecoder decodeIntegerForKey:@"itemID"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.text forKey:@"Text"];
    [aCoder encodeBool:self.checked forKey:@"Checked"];
    [aCoder encodeObject:self.dueDate forKey:@"DueDate"];
    [aCoder encodeBool:self.shouldRemind forKey:@"ShouldRemind"];
    [aCoder encodeInteger:self.itemID forKey:@"itemID"];
}

-(UILocalNotification*)notificationForThisItem{
    
    NSArray *allNotifications = [[UIApplication sharedApplication]scheduledLocalNotifications];
    
    for(UILocalNotification *notification in allNotifications){
        NSNumber *number = [notification.userInfo objectForKey:@"ItemID"];
        if (number!=nil&&[number integerValue] == self.itemID) {
            return notification;
        }
    }
    return nil;
    
    
}

-(void)scheduleNotification
{
    
    UILocalNotification *existingNotification = [self notificationForThisItem];
    
    if(existingNotification !=nil){
        NSLog(@"Found an exisint notification %@",existingNotification);
        
        [[UIApplication sharedApplication]cancelLocalNotification:existingNotification];
    }
    
    if(self.shouldRemind &&
       [self.dueDate compare:[NSDate date]] != NSOrderedAscending){
        
        UILocalNotification *localNotification = [[UILocalNotification alloc]init];
        
        localNotification.fireDate = self.dueDate;
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.alertBody = self.text;
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        
        [[UIApplication sharedApplication]scheduleLocalNotification:localNotification];
        
    }
    
    
}


-(void)dealloc{
    
    UILocalNotification *existingNotification = [self notificationForThisItem];
    if(existingNotification !=nil){
        NSLog(@"Removing exisint notification %@",existingNotification);
        
        [[UIApplication sharedApplication]cancelLocalNotification:existingNotification];
        
    }
}




@end
