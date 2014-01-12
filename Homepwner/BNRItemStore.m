//
//  BNRItemStore.m
//  Homepwner
//
//  Created by Ovi Bortas on 12/17/13.
//  Copyright (c) 2013 Ovi Bortas. All rights reserved.
//

#import "BNRItemStore.h"
#import "BNRItem.h"
#import "BNRImageStore.h"

@implementation BNRItemStore

- (void)calculateTotal
{
    self.totalValue = 0;
    
    for (BNRItem *item in allItems) {
        self.totalValue += item.valueInDollars;
    }
}

- (void)removeItem:(BNRItem *)p
{
    NSString *key = p.imageKey;
    [[BNRImageStore sharedStore]deleteImageForKey:key];
    [context deleteObject:p];
    
    [allItems removeObjectIdenticalTo:p];
    
}

- (void)moveItemAtIndex:(NSInteger)from toIndex:(NSInteger)to
{
    if (from == to) {
        return;
    }
    // get pointer to object being moved so we can re-insert it
    BNRItem *p = allItems[from];
    
    // Remove p from array
    [allItems removeObjectAtIndex:from];
    
    // Insert p in arry at new location
    [allItems insertObject:p atIndex:to];
    
    // Computing a new orderValue for the object that was moved
    double lowerBound = 0.0;
    
    // Is there an object before it in the array?
    if (to > 0) {
        lowerBound = [[allItems objectAtIndex:to -1]orderingValue];
    } else {
        lowerBound = [[allItems objectAtIndex:1]orderingValue] - 2.0;
    }
    
    double upperBound = 0.0;
    
    // Is there an object after it in the array?
    if (to < allItems.count -1) {
        upperBound = [[allItems objectAtIndex:to +1]orderingValue];
    } else {
        upperBound = [[allItems objectAtIndex:to -1]orderingValue] +2.0;
    }
    
    double newOrderingValue = (lowerBound + upperBound) / 2;
    NSLog(@"moving to order %f", newOrderingValue);
    p.orderingValue = newOrderingValue;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Read in Homepwner.xcdatamodeld
        model = [NSManagedObjectModel mergedModelFromBundles:nil];
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:model];
        
        // Where does the SQLite file go?
        NSString *path = self.itemArchivePath;
        NSURL *storeURL = [NSURL fileURLWithPath:path];
        
        NSError *error = nil;
        
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType
                               configuration:nil
                                         URL:storeURL
                                     options:nil
                                       error:&error]) {
            [NSException raise:@"Open failed" format:@"Reason: %@", [error localizedDescription]];
        }
        
        // Create the managed object context
        context = [[NSManagedObjectContext alloc]init];
        context.persistentStoreCoordinator = psc;
        
        // The managed object contexy can manage undo, but we dont need it
        context.undoManager = nil;
        
        [self loadAllItems];
    }
    return self;
}

- (NSArray*)allItems
{
    return  allItems;
}

- (BNRItem*)createItem
{
    double order;
    if (allItems.count == 0) {
        order = 1.0;
    } else {
        order = [[allItems lastObject]orderingValue] +1.0;
    }
    NSLog(@"Adding after %d items, order = %.2f", allItems.count, order);
    
    BNRItem *p = [NSEntityDescription insertNewObjectForEntityForName:@"BNRItem" inManagedObjectContext:context];
    p.orderingValue = order;
    NSString *randomSerialNumber = [NSString stringWithFormat:@"%c%c%c%c%c",
                                    '0' + rand() % 10,
                                    'A' + rand() % 26,
                                    '0' + rand() % 10,
                                    'A' + rand() % 26,
                                    '0' + rand() % 10];
    p.serialNumber = randomSerialNumber;
    p.itemName = @"Item Name";
    
    [allItems addObject:p];
    
    return p;
}

+ (BNRItemStore*)sharedStore
{
    static BNRItemStore *sharedStore = nil;
    if (!sharedStore) {
        sharedStore = [[super allocWithZone:nil]init];
    }
    return sharedStore;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedStore];
}

- (NSString*)itemArchivePath
{
    NSArray *docDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    // Get one and only document directory from that list
    NSString *doctdirectory = docDirectories[0];
    
    return [doctdirectory stringByAppendingPathComponent:@"store.data"];
}

- (void)loadAllItems
{
    if (!allItems) {
        NSFetchRequest *request = [[NSFetchRequest alloc]init];
        
        NSEntityDescription *e = [[model entitiesByName]objectForKey:@"BNRItem"];
        request.entity = e;
        
        NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"orderingValue" ascending:YES];
        request.sortDescriptors = @[sd];
        
        NSError *error;
        NSArray *result = [context executeFetchRequest:request error:&error];
        if (!result) {
            [NSException raise:@"Fetch failed" format:@"Reason: %@", [error localizedDescription]];
        }
        
        allItems = [[NSMutableArray alloc]initWithArray:result];
    }
}

- (NSArray*)allAssetTypes
{
    if (!allAsetTypes) {
        NSFetchRequest *request = [[NSFetchRequest alloc]init];
        NSEntityDescription *e = [[model entitiesByName]objectForKey:@"BNRAssetType"];
        
        request.entity = e;
        
        NSError *error;
        NSArray *result = [context executeFetchRequest:request error:&error];
        if (!result) {
            [NSException raise:@"Fetch failed" format:@"Reason: %@", [error localizedDescription]];
        }
        allAsetTypes = result.mutableCopy;
    }
    
    // Is this the first time the program is being run?
    if (allAsetTypes.count == 0) {
        NSManagedObject *type;
        type = [NSEntityDescription insertNewObjectForEntityForName:@"BNRAssetType" inManagedObjectContext:context];
        
        [type setValue:@"Furniture" forKey:@"label"];
        [allAsetTypes addObject:type];
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"BNRAssetType" inManagedObjectContext:context];
        
        [type setValue:@"Jewelry" forKey:@"label"];
        [allAsetTypes addObject:type];
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"BNRAssetType" inManagedObjectContext:context];
        
        [type setValue:@"Electronics" forKey:@"label"];
        [allAsetTypes addObject:type];
    }
    return  allAsetTypes;
}

- (BOOL)saveChanges
{
    NSError *err;
    BOOL successful = [context save:&err];
    if (!successful) {
        NSLog(@"Error saving: %@", [err localizedDescription]);
    }
    return successful;
}
@end
