//
//  DetailViewController.h
//  Homepwner
//
//  Created by Ovi Bortas on 12/17/13.
//  Copyright (c) 2013 Ovi Bortas. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BNRItem;

@interface DetailViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>
{
        __weak IBOutlet UITextField *nameField;
        __weak IBOutlet UITextField *serialNumberField;
        __weak IBOutlet UITextField *valueField;
        __weak IBOutlet UILabel *dateLabel;
        __weak IBOutlet UIImageView *imageView;
}


@property (nonatomic,strong) BNRItem *item;

- (IBAction)takePicture:(id)sender;
- (IBAction)backgroundTapped:(id)sender;
@end
