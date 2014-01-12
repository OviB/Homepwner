//
//  BNRImageStore.m
//  Homepwner
//
//  Created by Ovi Bortas on 12/21/13.
//  Copyright (c) 2013 Ovi Bortas. All rights reserved.
//

#import "BNRImageStore.h"

@implementation BNRImageStore

#pragma mark - Methods
- (NSString*)imagePathForKey:(NSString *)key
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    
    NSString *documentdirectory = documentDirectories[0];
    
    return [documentdirectory stringByAppendingString:key];
}
- (void)setImage:(UIImage *)i forKey:(NSString *)s
{
    [dictonary setObject:i forKey:s];
    
    // Create full path for image
    NSString *imagePath = [self imagePathForKey:s];
    
    // Turn image into JPEG data
    NSData *d = UIImageJPEGRepresentation(i, 0.5);
    
    // Write it to full path
    [d writeToFile:imagePath atomically:YES];
}

- (UIImage*)imageForKey:(NSString *)s
{
    // If possilbe, get it from the directory
    UIImage *result = [dictonary objectForKey:s];
    
    if (!result) {
        // Create UIImage object from file
        result = [UIImage imageWithContentsOfFile:[self imagePathForKey:s]];
        
        // If we wound an image on the file system, place it into the cache
        if (result)
            [dictonary setObject:result forKey:s];
        else
            NSLog(@"Error, unable to find %@", [self imagePathForKey:s]);
    }
    return result;
}

- (void)deleteImageForKey:(NSString *)s
{
    if (!s)
        return;
    [dictonary removeObjectForKey:s];
    
    NSString *path = [self imagePathForKey:s];
    [[NSFileManager defaultManager]removeItemAtPath:path error:NULL];
}

#pragma mark - Init Methods
+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedStore];
}

+ (BNRImageStore*)sharedStore
{
    static BNRImageStore *sharedStore = nil;
    if (!sharedStore) {
        // Create the singleton
        sharedStore = [[super allocWithZone:NULL]init];
    }
    return sharedStore;
}


- (id)init
{
    self = [super init];
    if (self) {
        dictonary = [[NSMutableDictionary alloc]init];
    }
    return self;
}
@end
