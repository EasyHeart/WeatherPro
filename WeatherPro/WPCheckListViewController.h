//
//  WPCheckListViewController.h
//  WeatherPro
//
//  Created by liuhang on 14-5-10.
//  Copyright (c) 2014年 liuhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPItemDetailViewController.h"
#import "WPCheckList.h"

@class WPCheckListViewController;


@interface WPCheckListViewController : UITableViewController<ItemDetailViewController>

@property (nonatomic, strong) WPCheckList *list;

- (IBAction)addItem;

@end
