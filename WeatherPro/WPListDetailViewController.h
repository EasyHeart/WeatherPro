//
//  WPLIstDetailViewController.h
//  WeatherPro
//
//  Created by liuhang on 14-5-12.
//  Copyright (c) 2014年 liuhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPIconPickerViewController.h"

@class WPListDetailViewController;
@class WPCheckList;

@protocol ListDetailViewController <NSObject>

- (void)ListDetailViewControllerDidCancel:(WPListDetailViewController *)controller;

- (void)ListDetailViewController:(WPListDetailViewController *)controller DidFinishAddingList:(WPCheckList *)list;

- (void)ListDetailViewController:(WPListDetailViewController *)controller DidFinishEditingList:(WPCheckList *)list;


@end

@interface WPListDetailViewController : UITableViewController<UITextFieldDelegate,IconPickerViewControllerDelegate>

@property (weak, nonatomic)id<ListDetailViewController>delegate;
@property (strong, nonatomic) NSIndexPath *textIndexPath;
@property (strong, nonatomic) NSIndexPath *imageIndexPath;
@property (strong, nonatomic) WPCheckList *listToEdit;
@property (strong, nonatomic) NSString *imageName;

- (IBAction)SaveButtonPressed;

@end
