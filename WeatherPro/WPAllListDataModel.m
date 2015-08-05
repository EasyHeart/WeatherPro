//
//  WPAllListDataModel.m
//  WeatherPro
//
//  Created by liuhang on 14-5-13.
//  Copyright (c) 2014年 liuhang. All rights reserved.
//

#import "WPAllListDataModel.h"
#import "WPCheckList.h"


@implementation WPAllListDataModel


-(void)sortChecklists{
    
    [self.lists sortUsingSelector:@selector(compare:)];
    
}


#pragma mark init初始化

-(id)init{
    
    if((self =[super init])){
        
        [self loadChecklists];
        [self registerDefaults];
    }
    return self;
}

#pragma mark 获取沙盒地址

-(NSString*)documentsDirectory{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    
    return documentsDirectory;
}

-(NSString*)dataFilePath{
    
    return [[self documentsDirectory]stringByAppendingPathComponent:@"Checklists.plist"];
}

-(void)saveChecklists{
    
    NSMutableData *data = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    
    [archiver encodeObject:_lists forKey:@"Checklists"];
    [archiver finishEncoding];
    
    [data writeToFile:[self dataFilePath] atomically:YES];
    
    
}

-(void)loadChecklists{
    
    NSString *path = [self dataFilePath];
    
    if([[NSFileManager defaultManager]fileExistsAtPath:path]){
        
        NSData *data = [[NSData alloc]initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
        
        self.lists = [unarchiver decodeObjectForKey:@"Checklists"];
        
        [unarchiver finishDecoding];
    }else{
        
        self.lists = [[NSMutableArray alloc]initWithCapacity:20];
    }
    
}

+ (NSInteger)nextCheckListItemID
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger itemID = [userDefaults integerForKey:@"CheckListItemID"];
    [userDefaults setInteger:itemID+1 forKey:@"CheckListItemID"];
    [userDefaults synchronize];
    return itemID;
}

-(void)registerDefaults{
    
    NSDictionary *dictionary = @{@"ChecklistItemId":@0};
    
    [[NSUserDefaults standardUserDefaults]registerDefaults:dictionary];
}

@end
