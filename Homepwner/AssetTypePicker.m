//
//  AssetTypePicker.m
//  Homepwner
//
//  Created by Ovi Bortas on 12/24/13.
//  Copyright (c) 2013 Ovi Bortas. All rights reserved.
//

#import "AssetTypePicker.h"
#import "BNRItemStore.h"
#import "BNRItem.h"

@interface AssetTypePicker ()

@end

@implementation AssetTypePicker

- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)addButtonPressed
{
    UITextField *addTextField = [[UITextField alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 30.0f)];
    addTextField.borderStyle = UITextBorderStyleRoundedRect;
    addTextField.placeholder = @"Add Type";
    
    self.navigationItem.titleView = addTextField;
    
}

- (id)init
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                          target:self
                                                                                          action:@selector(addButtonPressed)];
    
    return [super initWithStyle:UITableViewStyleGrouped];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[[BNRItemStore sharedStore]allAssetTypes]count];}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UITabelViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSArray *allAssets = [[BNRItemStore sharedStore]allAssetTypes];
    NSManagedObject *assetType = [allAssets objectAtIndex:indexPath.row];
    
    // Use key-value coding to get the asset types label
    NSString *assetlabel = [assetType valueForKey:@"label"];
    cell.textLabel.text = assetlabel;
    
    // Checkmark the one that is currently selected
    if (assetType == self.item.assetType) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    NSArray *allAssets = [[BNRItemStore sharedStore]allAssetTypes];
    NSManagedObject *assetType = [allAssets objectAtIndex:indexPath.row];
    self.item.assetType = assetType;
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
