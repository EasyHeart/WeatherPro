//
//  WPCheckList.m
//  WeatherPro
//
//  Created by liuhang on 14-5-12.
//  Copyright (c) 2014年 liuhang. All rights reserved.
//

#import "WPCheckList.h"
#import "WPCheckListItem.h"

@implementation WPCheckList

-(int)countUncheckedItems{
    
    int count = 0;
    for(WPCheckListItem *item in self.items){
        if(!item.checked){
            count+=1;
        }
    }
    return count;
    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super init])) {
        self.items = [aDecoder decodeObjectForKey:@"items"];
        self.imageName = [aDecoder decodeObjectForKey:@"image"];
        self.name  = [aDecoder decodeObjectForKey:@"name"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.items forKey:@"items"];
    [aCoder encodeObject:self.imageName forKey:@"image"];
    [aCoder encodeObject:self.name forKey:@"name"];
}

- (id)copyWithZone:(NSZone *)zone
{
    WPCheckList *copy = [[WPCheckList alloc]init];
    copy.items = [self.items copyWithZone:zone];
    copy.imageName = [self.imageName copyWithZone:zone];
    copy.name = [self.name copyWithZone:zone];
    return self;
}

-(NSComparisonResult)compare:(WPCheckList*)otherChecklist{
    
    return [self.name localizedStandardCompare:otherChecklist.name];
}

@end
