//
//  WPStartViewController.m
//  WeatherPro
//
//  Created by liuhang on 14-5-10.
//  Copyright (c) 2014年 liuhang. All rights reserved.
//

#import "WPStartViewController.h"
#import "WPNavigationController.h"

@interface WPStartViewController ()

@end

@implementation WPStartViewController

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
    // Do any additional setup after loading the view from its nib.
    self.title = @"开始页面";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"目录" style:UIBarButtonItemStylePlain target:(WPNavigationController *)self.navigationController action:@selector(showMenu)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
