//
//  HomepwnerItemCell.m
//  Homepwner
//
//  Created by Ovi Bortas on 12/20/13.
//  Copyright (c) 2013 Ovi Bortas. All rights reserved.
//

#import "HomepwnerItemCell.h"

@implementation HomepwnerItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // Make thumbnailView act like a button
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                               action:@selector(showImage:)];
    [self.thumbnailView addGestureRecognizer:singleTap];
}

- (void)showImage:(id)sender
{
    // Get the name of this method
    NSString *selector = NSStringFromSelector(_cmd);
    
    // Selector is now "showImage:atIndexPath:"
    selector = [selector stringByAppendingString:@"atIndexPath:"];
    
    // Prepar a selector for this string
    SEL newSelector = NSSelectorFromString(selector);
    
    NSIndexPath *indexPath = [self.theTableView indexPathForCell:self];
    if (indexPath) {
        if ([self.controller respondsToSelector:newSelector]) {
            
            // Ignore warning for this line - may or maynot appear, doesnt matter
            [self.controller performSelector:newSelector withObject:sender withObject:indexPath];
        }
    }
}

@end
