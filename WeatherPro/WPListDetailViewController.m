//
//  WPLIstDetailViewController.m
//  WeatherPro
//
//  Created by liuhang on 14-5-12.
//  Copyright (c) 2014年 liuhang. All rights reserved.
//

#import "WPListDetailViewController.h"
#import "WPCheckList.h"

static NSString *TextCellIdentifier = @"TextCell";
static NSString *ImageCellIdentifier = @"ImageCell";

@interface WPListDetailViewController ()

@end

@implementation WPListDetailViewController


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(SaveButtonPressed)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(CancelButtonPressed)];
    
    
    UINib *nib = [UINib nibWithNibName:@"WPListDetailTextCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:TextCellIdentifier ];
    UINib *imageNib = [UINib nibWithNibName:@"WPListDetailImageCell" bundle:nil];
    [self.tableView registerNib:imageNib forCellReuseIdentifier:ImageCellIdentifier];
    if (self.listToEdit != nil) {
        self.title = @"编辑列表";
        [self textField].text = self.listToEdit.name;
        self.navigationItem.rightBarButtonItem.enabled = YES;
        _imageName = self.listToEdit.imageName;
    }
}

- (IBAction)SaveButtonPressed
{
    if (self.listToEdit == nil) {
        WPCheckList *checkList = [[WPCheckList alloc]init];
        checkList.name = [self textField].text;
        checkList.imageName = _imageName;
        [self.delegate ListDetailViewController:self DidFinishAddingList:checkList];
    } else {
        self.listToEdit.name = [self textField].text;
        self.listToEdit.imageName = _imageName;
        [self.delegate ListDetailViewController:self DidFinishEditingList:self.listToEdit];
    }
}

- (void)CancelButtonPressed
{
    [self.delegate ListDetailViewControllerDidCancel:self];
}

- (UITextField *)textField
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.textIndexPath];
    return   ((UITextField *)[cell viewWithTag:100]);

}

- (UIImageView *)imageView
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.imageIndexPath];
    return ((UIImageView *)[cell viewWithTag:120]);
}

- (BOOL)textField:(UITextField *)theTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newText = [theTextField.text stringByReplacingCharactersInRange:range withString:string];
    self.navigationItem.rightBarButtonItem.enabled = ([newText length] > 0);
    return YES;
}

-(void)iconPicker:(WPIconPickerViewController *)picker didPickIcon:(NSString *)iconName{
    
    
    _imageName = iconName;
    [self imageView].image = [UIImage imageNamed:_imageName];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:TextCellIdentifier forIndexPath:indexPath];
        self.textIndexPath = indexPath;
        UITextField *textFiled = (UITextField *)[cell viewWithTag:100];
        [textFiled becomeFirstResponder ];
        if (self.listToEdit != nil) {
            textFiled.text = self.listToEdit.name;
        }
        
    } else if (indexPath.section == 1)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:ImageCellIdentifier forIndexPath:indexPath];
        self.imageIndexPath = indexPath;
        
        ((UIImageView *)[cell viewWithTag:120]).image= [UIImage imageNamed:_imageName];
    }
    return cell;
}

#pragma mark - Table view delegate
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section ==1){
        return indexPath;
    }else{
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        WPIconPickerViewController *controller = [[WPIconPickerViewController alloc]init];
        controller.delegate =self;
        [self.navigationController pushViewController:controller animated:YES];
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
