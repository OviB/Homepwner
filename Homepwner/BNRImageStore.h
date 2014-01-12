//
//  BNRImageStore.h
//  Homepwner
//
//  Created by Ovi Bortas on 12/21/13.
//  Copyright (c) 2013 Ovi Bortas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRImageStore : NSObject
{
    NSMutableDictionary *dictonary;
}

+ (BNRImageStore*)sharedStore;

- (void)setImage:(UIImage*)i forKey:(NSString*)s;
- (UIImage*)imageForKey:(NSString*)s;
- (void)deleteImageForKey:(NSString*)s;
- (NSString*)imagePathForKey:(NSString*)key;


@end
