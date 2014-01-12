//
//  BNRItemStore.h
//  Homepwner
//
//  Created by Ovi Bortas on 12/17/13.
//  Copyright (c) 2013 Ovi Bortas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BNRItem;

@interface BNRItemStore : NSObject
{
    NSMutableArray *allItems;
    NSMutableArray *allAsetTypes;
    NSManagedObjectContext *context;
    NSManagedObjectModel *model;
}

@property (nonatomic) int totalValue;

+ (BNRItemStore*)sharedStore;

- (void)removeItem:(BNRItem*)p;
- (void)moveItemAtIndex:(NSInteger)from toIndex:(NSInteger)to;

- (NSArray*)allItems;
- (BNRItem*)createItem;

- (NSString*)itemArchivePath;
- (BOOL)saveChanges;

- (void)loadAllItems;

- (NSArray*)allAssetTypes;

- (void)calculateTotal;
@end
