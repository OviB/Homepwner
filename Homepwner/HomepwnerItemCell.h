//
//  HomepwnerItemCell.h
//  Homepwner
//
//  Created by Ovi Bortas on 12/20/13.
//  Copyright (c) 2013 Ovi Bortas. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HomepwnerItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@property (nonatomic,weak) id controller;
@property (nonatomic,weak) UITableView *theTableView;

- (void)showImage:(id)sender;

@end
