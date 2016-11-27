//
//  SectionDataSource.m
//  TVPhone
//
//  Created by Liya on 15/11/9.
//  Copyright (c) 2015年 Liya. All rights reserved.
//

#import "SectionDataSource.h"

@implementation SectionDataSource
- (id)initWithItems:(NSArray *)anItems
              title:(NSString *)title
{
    self = [super init];
    if (self) {
        [self resetItems:anItems];
        self.Title = title;
    }
    return self;
}


- (NSInteger)indexOfItme:(id)item
{
    return [_items indexOfObject:item];
}

- (id)itemAtIndex:(NSInteger)index
{
    if (index >= [self.items count] || index < 0)
        return nil;
    NSArray *tmpItems = [self.items copy];
    return tmpItems[index];
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self itemAtIndex:indexPath.row];
}

- (void)itemDelIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= [self.items count])
        return;

    @synchronized(_items)
    {
        [_items removeObjectAtIndex:indexPath.row];
    }
    
}


- (void)resetItems:(NSArray *)anItems
{
    if ([anItems isKindOfClass:[NSMutableArray class]]) {
        self.items = (NSMutableArray *)anItems;
    } else {
        if (anItems)
            self.items = [NSMutableArray arrayWithArray:anItems];
        else
            self.items = nil;
    }
}



- (void)addItems:(NSArray *)anItems
{
    if (!self.items)
    {
        if ([anItems isKindOfClass:[NSMutableArray class]]) {
            self.items = (NSMutableArray *)anItems;
        } else {
            self.items = [NSMutableArray arrayWithArray:anItems];
        }
    }
    
    else
    {
        @synchronized(_items)
        {
            [_items addObjectsFromArray:anItems];
        }
    }
}

- (NSInteger)getItemsCount
{
    return [_items count];
}


- (void)deleteItemWithObj:(id)obj
{
    @synchronized(_items)
    {
        [_items removeObject:obj];
    }
}

- (void)deleteItemWithItems:(NSArray *)anItems
{
    @synchronized(_items)
    {
        [_items removeObjectsInArray:anItems];
    }
}

- (void)dealloc
{
    [self.items removeAllObjects], self.items = nil;
}
@end
