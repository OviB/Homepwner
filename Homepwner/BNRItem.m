//
//  BNRItem.m
//  Homepwner
//
//  Created by Ovi Bortas on 12/24/13.
//  Copyright (c) 2013 Ovi Bortas. All rights reserved.
//

#import "BNRItem.h"


@implementation BNRItem

@dynamic itemName;
@dynamic serialNumber;
@dynamic valueInDollars;
@dynamic dateCreated;
@dynamic imageKey;
@dynamic thumbnailData;
@dynamic thumbnail;
@dynamic orderingValue;
@dynamic assetType;


- (void)awakeFromFetch
{
    [super awakeFromFetch];
    
    UIImage *tn = [UIImage imageWithData:self.thumbnailData];
    [self setPrimitiveValue:tn forKey:@"thumbnail"];
}

- (void)awakeFromInsert
{
    [super awakeFromInsert];
    
    NSTimeInterval t = [[NSDate date]timeIntervalSinceReferenceDate];
    self.dateCreated = t;
}

- (void)setThumbnailDataForImage:(UIImage *)image
{
    CGSize originalImageSize = image.size;
    
    // The rectangle of the thumnail
    CGRect newRect = CGRectMake(0.0f, 0.0f, 40.0f, 40.0f);
    
    // Figure out a scaling ration to make sure we maintail the same aspect ratio
    float ratio = MAX(newRect.size.width / originalImageSize.width, newRect.size.height / originalImageSize.height);
    
    // Create a transparent bitmap context with a scaling factor equal to that of the screen
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0);
    
    // Create a path that is rounded rectangle
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect cornerRadius:5.0f];
    
    // Make all subsequent drawing clip to this rectangle
    [path addClip];
    
    // Center the image in the thumbnail rectangle
    CGRect projectRect;
    projectRect.size.width = ratio * originalImageSize.width;
    projectRect.size.height = ratio * originalImageSize.height;
    projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0f;
    projectRect.origin.y = (newRect.size.height - projectRect.size.height) / 2.0f;
    
    // Draw the image on it
    [image drawInRect:projectRect];
    
    // Get the image from the image context, keep it as our thumbnail
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    self.thumbnail = smallImage;
    
    // Get the PNG representation of the image and set it as our archivable data
    NSData *data = UIImagePNGRepresentation(smallImage);
    self.thumbnailData = data;
    
    // Cleanup image context resources, we're done
    UIGraphicsEndImageContext();
}

@end
