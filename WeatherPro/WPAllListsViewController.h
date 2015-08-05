//
//  WPAllListsViewController.h
//  WeatherPro
//
//  Created by liuhang on 14-5-12.
//  Copyright (c) 2014年 liuhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPCheckList.h"
#import "WPListDetailViewController.h"
#import "WPCheckListViewController.h"
#import "WPAllListDataModel.h"

@interface WPAllListsViewController : UITableViewController<ListDetailViewController>

@property (strong , nonatomic) WPAllListDataModel *dataModel;

@end
