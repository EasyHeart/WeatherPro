//
//  WPItemDetailViewController.h
//  WeatherPro
//
//  Created by liuhang on 14-5-10.
//  Copyright (c) 2014年 liuhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WPItemDetailViewController;
@class WPCheckListItem;

@protocol ItemDetailViewController <NSObject>

- (void)ItemDetailViewControllerDidCancel:(WPItemDetailViewController *)controller;

- (void)ItemDetailViewController:(WPItemDetailViewController *)controller didFinishAddingItem:(WPCheckListItem *)item;

- (void)ItemDetailViewController:(WPItemDetailViewController *)controller didFinishEditingItem:(WPCheckListItem *)item;

@end

@interface WPItemDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *TextField;

@property (weak, nonatomic)id <ItemDetailViewController>delegate;

@property (strong, nonatomic) WPCheckListItem *itemToEdit;
@property(nonatomic,weak) IBOutlet UISwitch *switchControl;
@property (weak, nonatomic) IBOutlet UIDatePicker *DatePicker;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

- (IBAction)done;

- (IBAction)cancel;
- (IBAction)dueDateButtonPressed:(UIButton *)sender;

@end
