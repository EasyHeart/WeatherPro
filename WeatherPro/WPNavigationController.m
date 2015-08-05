//
//  WPNavigationController.m
//  WeatherPro
//
//  Created by liuhang on 14-5-9.
//  Copyright (c) 2014年 liuhang. All rights reserved.
//

#import "WPNavigationController.h"
#import "WPMenuViewController.h"
#import "UIViewController+REFrostedViewController.h"

@interface WPNavigationController ()

@property (strong, nonatomic) WPMenuViewController *menuViewController;

@end

@implementation WPNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)showMenu
{
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
}



@end
