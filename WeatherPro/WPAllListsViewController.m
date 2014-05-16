//
//  WPAllListsViewController.m
//  WeatherPro
//
//  Created by liuhang on 14-5-12.
//  Copyright (c) 2014年 liuhang. All rights reserved.
//

#import "WPAllListsViewController.h"
#import "WPCheckListViewController.h"
#import "WPNavigationController.h"
#import "WPListDetailViewController.h"

static NSString *CellIdentifier = @"Cell";

@interface WPAllListsViewController ()

@end

@implementation WPAllListsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
 
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"全部列表";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"目录"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:(WPNavigationController *)self.navigationController
                                                                            action:@selector(showMenu)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStyleBordered target:self action:@selector(addCheckList)];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    
    self.dataModel = [[WPAllListDataModel alloc]init];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.dataModel saveChecklists];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}


- (void)addCheckList
{
    WPListDetailViewController *detail = [[WPListDetailViewController alloc]initWithStyle:UITableViewStyleGrouped];
    detail.delegate =self;
    detail.title = @"添加列表";
    detail.imageName = @"Folder";
    [self.navigationController pushViewController:detail animated:YES];
}


#pragma mark - List Detail Delegate
- (void)ListDetailViewControllerDidCancel:(WPListDetailViewController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)ListDetailViewController:(WPListDetailViewController *)controller DidFinishAddingList:(WPCheckList *)list
{
    [self.dataModel.lists addObject:list];
    [self.dataModel sortChecklists];
    [self.tableView reloadData];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)ListDetailViewController:(WPListDetailViewController *)controller DidFinishEditingList:(WPCheckList *)list
{
    [self.dataModel sortChecklists];
    [self.tableView reloadData];

    [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.dataModel.lists count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    WPCheckList *checklist = self.dataModel.lists[indexPath.row];
    
    cell.textLabel.text = checklist.name;
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    cell.imageView.image = [UIImage imageNamed:checklist.imageName];
    
    int count = [checklist countUncheckedItems];
    if([checklist.items count]==0){
        cell.detailTextLabel.text = @"(No Items)";
    }else if(count ==0){
        cell.detailTextLabel.text =@"全部搞定收工！";
    }else{
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d Remaining",[checklist countUncheckedItems]];
    }

    
    return cell;
}

#pragma mark Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WPCheckListViewController *check = [[WPCheckListViewController alloc]init];
    WPCheckList *list = self.dataModel.lists[indexPath.row];
    check.list = list;
    check.title = list.name;
    [self.navigationController pushViewController:check animated:YES];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    WPCheckList *list = self.dataModel.lists[indexPath.row];
    WPListDetailViewController *detail = [[WPListDetailViewController alloc]initWithStyle:UITableViewStyleGrouped];
    detail.delegate =self;
    detail.listToEdit = list;
    [self.navigationController pushViewController:detail animated:YES];

}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.dataModel.lists removeObjectAtIndex:indexPath.row];
    
    NSArray *indexPaths = @[indexPath];
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


@end
