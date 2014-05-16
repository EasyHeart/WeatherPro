//
//  WPCheckListViewController.m
//  WeatherPro
//
//  Created by liuhang on 14-5-10.
//  Copyright (c) 2014年 liuhang. All rights reserved.
//

#import "WPCheckListViewController.h"
#import "WPCheckListItem.h"
#import "WPNavigationController.h"

#define kFileName @"Checklists.plist"
#define kDatakey @"CheckListItems"

static NSString *CellIdentifier = @"CheckListItem";


@interface WPCheckListViewController ()

@end

@implementation WPCheckListViewController

- (id)init
{
    if ((self = [super init])) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addItem)];
    //register nib
    UINib *nib = [UINib nibWithNibName:@"WPCheckListCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
}


- (void)addItem
{
    if (self.list.items == nil) {
        self.list.items = [[NSMutableArray alloc]initWithCapacity:20];
    }
    WPItemDetailViewController* _addView = [[WPItemDetailViewController alloc] init];
    _addView.delegate = self;
    [self.navigationController pushViewController:_addView animated:YES];
    
}


#pragma mark -
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.list.items count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    
    WPCheckListItem *item = self.list.items[indexPath.row];
    [self configureTextForCell:cell withChecklistItem:item];
    [self configureCheckmarkForCell:cell withChecklistItem:item];
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    return cell;
}

- (void)configureCheckmarkForCell:(UITableViewCell *)cell withChecklistItem:(WPCheckListItem *)item
{
    UILabel *label = (UILabel *)[cell viewWithTag:101];
    if (item.checked) {
        label.hidden = NO;
    } else {
        label.hidden = YES;
    }
    label.textColor = self.view.tintColor;
}

- (void)configureTextForCell:(UITableViewCell *)cell withChecklistItem:(WPCheckListItem *)item
{
    UILabel *label = (UILabel *)[cell viewWithTag:100];
    label.text = [NSString stringWithFormat:@"%ld:%@",(long)item.itemID,item.text];
}

#pragma -
#pragma mark - Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    WPCheckListItem *item = self.list.items[indexPath.row];
    [item toggleChecked];
    [self configureCheckmarkForCell:cell withChecklistItem:item];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Delete the row from the data source
    [self.list.items removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    WPItemDetailViewController* _addView = [[WPItemDetailViewController alloc]init];
    _addView.delegate = self;
    _addView.itemToEdit = self.list.items[indexPath.row];
    [self.navigationController pushViewController:_addView animated:YES];
}

#pragma mark - AddItem Delegate
- (void)ItemDetailViewControllerDidCancel:(WPItemDetailViewController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)ItemDetailViewController:(WPItemDetailViewController *)controller didFinishAddingItem:(WPCheckListItem *)item
{
    NSInteger newRowIndex = [self.list.items count];
    [self.list.items addObject:item];
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:newRowIndex inSection:0];
    NSArray *indexPaths = @[path];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)ItemDetailViewController:(WPItemDetailViewController *)controller didFinishEditingItem:(WPCheckListItem *)item
{
    NSInteger index = [self.list.items indexOfObject:item];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    [self configureTextForCell:cell withChecklistItem:item];
    [self.navigationController popViewControllerAnimated:YES];

}

@end
