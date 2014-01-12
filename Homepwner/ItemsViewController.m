//
//  ItemsViewController.m
//  Homepwner
//
//  Created by Ovi Bortas on 12/17/13.
//  Copyright (c) 2013 Ovi Bortas. All rights reserved.
//

#import "ItemsViewController.h"
#import "BNRItem.h"
#import "BNRItemStore.h"
#import "HomepwnerItemCell.h"
#import "BNRImageStore.h"
#import "ImageViewController.h"

@implementation ItemsViewController

static NSString *homeItemCellID = @"CellID";

#pragma mark - Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Load the NIB file
    UINib *nib = [UINib nibWithNibName:@"HomepwnerItemCell" bundle:nil];
    
    // Register this NIB which contains the cell
    [self.tableView registerNib:nib forCellReuseIdentifier:homeItemCellID];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

#pragma mark - Button Actions
- (void)addNewItem:(id)sender
{
    // Create a new BNRItem and add it to the store
    BNRItem *newItem = [[BNRItemStore sharedStore]createItem];
    
    // Figure out where that item is in the array
    NSInteger lastRow = [[BNRItemStore sharedStore].allItems indexOfObject:newItem];
    
    NSIndexPath *ip = [NSIndexPath indexPathForRow:lastRow inSection:0];
    
    // Insert this new row into the table
    [self.tableView insertRowsAtIndexPaths:@[ip]
                          withRowAnimation:UITableViewRowAnimationTop];
}


# pragma mark - UITableView
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController * detailViewController = [[DetailViewController alloc]init];
    
    NSArray *items = [[BNRItemStore sharedStore]allItems];
    BNRItem *selectedItem = items[indexPath.row];
    
    // Give detail view conroller a pointer to the item object in row
    detailViewController.item = selectedItem;
    
    // Push it onto the top of the navigation controllers stack
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [BNRItemStore sharedStore].allItems.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Set the text on the cell with the description of the item that is at the nth index of items, where n = row this cell
    // will appear in on the tableview
    BNRItem *p = [BNRItemStore sharedStore].allItems[indexPath.row];
    
    // Get the new or recycled cell
    HomepwnerItemCell *cell = [tableView dequeueReusableCellWithIdentifier:homeItemCellID];
    
    // Set controller and tableView to self
    cell.controller = self;
    cell.theTableView = tableView;
    
    // Configure the cell with the BNRItem
    cell.nameLabel.text = p.itemName;
    cell.serialNumberLabel.text = p.serialNumber;
    cell.valueLabel.text = [NSString stringWithFormat:@"$%d", p.valueInDollars];
    
    cell.thumbnailView.image = p.thumbnail;
    
    return  cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // If the table view is asking to commit a delete command..
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        BNRItemStore *ps = [BNRItemStore sharedStore];
        NSArray *items = ps.allItems;
        BNRItem *p = [items objectAtIndex:indexPath.row];
        [ps removeItem:p];
        
        // We also remove that row from the table view with an animation
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [tableView reloadData];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[BNRItemStore sharedStore]moveItemAtIndex:sourceIndexPath.row
                                       toIndex:destinationIndexPath.row];
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    [[BNRItemStore sharedStore]calculateTotal];
    NSString *headerTitle = [NSString stringWithFormat:@"Total Value: $%d", [BNRItemStore sharedStore].totalValue];
    
    return headerTitle;
}

#pragma mark - Other
- (void)showImage:(id)sender atIndexPath:(NSIndexPath*)ip
{
    NSLog(@"Worked %@", ip);

    // Get the item for the index path
    BNRItem *item = [[[BNRItemStore sharedStore]allItems]objectAtIndex:ip.row];
    
    NSString *imageKey = item.imageKey;
    
    // If there is no image, we dont need to display anything
    UIImage *img = [[BNRImageStore sharedStore]imageForKey:imageKey];
    if (!img)
        return;
    
    // Make a rectange that the fram of the button relative to our table view
    //CGRect rect = [self.view convertRect:[sender bounds] fromView:sender];
    
    // Create a new ImageViewController and set its image
    ImageViewController *ivc = [[ImageViewController alloc]init];
    ivc.image = img;
    
    [self.navigationController pushViewController:ivc animated:YES];
    NSLog(@"Logged");
}

#pragma mark - init Methods
- (id)init
{
    // Call the superclasses designated initalizer
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
        self.title = @"Homepwner";
            
        // Create a new bar button item that will send addNewItem: to ItemsViewController
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                target:self
                                                                                action:@selector(addNewItem:)];
        // Set this bar button itemas the right item in the navigationItem
        self.navigationItem.rightBarButtonItem = bbi;
            
        self.navigationItem.leftBarButtonItem = self.editButtonItem;
        
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

@end
