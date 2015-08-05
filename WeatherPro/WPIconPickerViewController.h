//
//  WPIconPickerViewController.h
//  WeatherPro
//
//  Created by liuhang on 14-5-10.
//  Copyright (c) 2014年 liuhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WPIconPickerViewController;

@protocol IconPickerViewControllerDelegate <NSObject>

-(void)iconPicker:(WPIconPickerViewController*)picker didPickIcon:(NSString*)iconName;

@end

@interface WPIconPickerViewController : UITableViewController

@property(nonatomic,weak)id <IconPickerViewControllerDelegate> delegate;

@end
