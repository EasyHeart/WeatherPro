//
//  WPItemDetailViewController.m
//  WeatherPro
//
//  Created by liuhang on 14-5-10.
//  Copyright (c) 2014年 liuhang. All rights reserved.
//

#import "WPItemDetailViewController.h"
#import "WPCheckListItem.h"

@interface WPItemDetailViewController (){
    NSDate *_dueDate;
    BOOL _datePickerVisible;

}

@end

@implementation WPItemDetailViewController

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
    self.title = @"添加项目";
    UIBarButtonItem *Done = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
    self.navigationItem.rightBarButtonItem = Done;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
    if (self.itemToEdit != nil) {
        self.title = @"编辑项目";
        self.TextField.text = self.itemToEdit.text;
        self.switchControl.on = self.itemToEdit.shouldRemind;
        _dueDate = self.itemToEdit.dueDate;
        } else {
        self.switchControl.on = NO;
        _dueDate = [NSDate date];
    }
    self.DatePicker.hidden = YES;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    self.dateLabel.text = [formatter stringFromDate:_dueDate];
}

- (IBAction)done
{
    if (self.itemToEdit == nil) {
        WPCheckListItem *item = [[WPCheckListItem alloc]init];
        item.text = self.TextField.text;
        item.checked = NO;
        item.shouldRemind = self.switchControl.on;
        item.dueDate = _dueDate;
        
        [item scheduleNotification];
        [self.delegate ItemDetailViewController:self didFinishAddingItem:item];
    }else {
        self.itemToEdit.text = self.TextField.text;
        self.itemToEdit.shouldRemind = self.switchControl.on;
        self.itemToEdit.dueDate = _dueDate;
        
        [self.itemToEdit scheduleNotification];
        [self.delegate ItemDetailViewController:self didFinishEditingItem:self.itemToEdit];
    }
}

- (IBAction)cancel
{
    [self.delegate ItemDetailViewControllerDidCancel:self];
}

- (IBAction)dueDateButtonPressed:(UIButton *)sender {
    if (self.DatePicker.hidden == YES) {
        [self.TextField resignFirstResponder];
        self.DatePicker.hidden = NO;
        [self.DatePicker setDate:_dueDate animated:YES];
    } else {
        self.DatePicker.hidden = YES;
        _dueDate = self.DatePicker.date;
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        self.dateLabel.text = [formatter stringFromDate:_dueDate];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.TextField becomeFirstResponder];
}


@end
