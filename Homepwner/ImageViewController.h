//
//  ImageViewController.h
//  Homepwner
//
//  Created by Ovi Bortas on 12/21/13.
//  Copyright (c) 2013 Ovi Bortas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController
{
    __weak IBOutlet UIImageView *imageView;
    __weak IBOutlet UIScrollView *scrollView;
    
}
@property (nonatomic,strong) UIImage *image;

@end
