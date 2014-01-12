//
//  DetailViewController.m
//  Homepwner
//
//  Created by Ovi Bortas on 12/17/13.
//  Copyright (c) 2013 Ovi Bortas. All rights reserved.
//

#import "DetailViewController.h"
#import "BNRItem.h"
#import "BNRImageStore.h"
#import "AssetTypePicker.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UIButton *assetTypeButton;

@end

@implementation DetailViewController

#pragma mark = Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    nameField.text = self.item.itemName;
    serialNumberField.text = self.item.serialNumber;
    valueField.text = [NSString stringWithFormat:@"%d", self.item.valueInDollars];
    
    // Create a NSdateFormatter that will turn a date into a simple date string
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc]init];
    dateFormater.dateStyle = NSDateFormatterMediumStyle;
    dateFormater.timeStyle = NSDateFormatterNoStyle;
    
    // Use filtered NSdate object to set dateLabel contents
    //dateLabel.text = [dateFormater stringFromDate:[self.item dateCreated]];
    
    // Convert time intervals to NSDate
    NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:[self.item dateCreated]];
    dateLabel.text = [dateFormater stringFromDate:date];
    
    NSString *imageKey = self.item.imageKey;
    
    if (imageKey) {
        // Get image for image key from image store
        UIImage *imageToDispaly = [[BNRImageStore sharedStore]imageForKey:imageKey];
        
        // Use that image to put on the screen in imageview
        imageView.image = imageToDispaly;
        NSLog(@"Image");
    } else {
        imageView.image = nil;
        NSLog(@"No Image");
    }
    NSString *typeLabel = [[self.item assetType]valueForKey:@"label"];
    if (!typeLabel)
        typeLabel = @"None";
        
        [self.assetTypeButton setTitle:[NSString stringWithFormat:@"Type: %@", typeLabel] forState:UIControlStateNormal];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Clear first responder
    [self.view endEditing:YES];
    
    // "Save" changes to item
    self.item.itemName = nameField.text;
    self.item.serialNumber = serialNumberField.text;
    self.item.valueInDollars = valueField.text.intValue;
}

#pragma mark - Button
- (IBAction)showAssetTypePicker:(id)sender
{
    [self.view endEditing:YES];
    
    AssetTypePicker *assetTypePicker = [[AssetTypePicker alloc]init];
    assetTypePicker.item = self.item;
    
    [self.navigationController pushViewController:assetTypePicker animated:YES];
}


#pragma mark - ImagePicker
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *oldKey = self.item.imageKey;
    
    // Did the item already have an image?
    if (oldKey) {
        // Delete the old image
        [[BNRImageStore sharedStore]deleteImageForKey:oldKey];
    }
    
    // Get picker from info library
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self.item setThumbnailDataForImage:image];
    
    // Create a CFUUID object - it knows how to create unique identifier string
    CFUUIDRef newUniqueID = CFUUIDCreate(kCFAllocatorDefault);
    
    // Create a string from unique identifier
    CFStringRef newUniqueIDString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueID);
    
    // Use that unique ID to set our items imageKey
    NSString *key = (__bridge NSString*)newUniqueIDString;
    self.item.imageKey = key;
    
    // Store image in the BNRItemStore with this key
    [[BNRImageStore sharedStore]setImage:image forKey:self.item.imageKey];
    
    CFRelease(newUniqueIDString);
    CFRelease(newUniqueID);
    
    // Put that image onto the screen in our view
    imageView.image = image;
    
    // Take image picker off the screen, you must call this dismiss method
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TextField
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

#pragma mark - Custome Setters/Getters
- (void)setItem:(BNRItem *)item
{
    _item = item;
    
    // Set nav title to iem selected
    self.navigationItem.title = self.item.itemName;
}

- (IBAction)takePicture:(id)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    
    // If our device has a camera, wewant to take a picure, otherwise, we just pick from the photo library
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    imagePicker.delegate = self;
    
    [[UIApplication sharedApplication]setStatusBarHidden:YES];
    
    // place image picker on the screen
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}

- (IBAction)backgroundTapped:(id)sender {
    [self.view endEditing:YES];
}
@end


















