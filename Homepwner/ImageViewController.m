//
//  ImageViewController.m
//  Homepwner
//
//  Created by Ovi Bortas on 12/21/13.
//  Copyright (c) 2013 Ovi Bortas. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()

@end

@implementation ImageViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGSize sz = self.image.size;
    scrollView.contentSize = sz;
    imageView.frame = CGRectMake(0.0f, 0.0f, sz.width, sz.height);
    
    imageView.image = self.image;
}


@end
