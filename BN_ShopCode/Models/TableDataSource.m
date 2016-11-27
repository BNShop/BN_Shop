//
//  TableDataSource.m
//  BN_Shop
//
//  Created by Liya on 16/11/12.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "TableDataSource.h"

@interface TableDataSource ()

@property (nonatomic, copy) NSString *cellIdentifier;
@property (nonatomic, copy) TableViewCellConfigureBlock configureCellBlock;
@property (nonatomic, strong) NSMutableArray *items;

@end

@implementation TableDataSource

- (id)initWithItems:(NSArray *)anItems
     cellIdentifier:(NSString *)aCellIdentifier
 configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock
{
    self = [super init];
    if (self) {
        [self resetItems:anItems];
        self.cellIdentifier = aCellIdentifier;
        self.configureCellBlock = aConfigureCellBlock;
    }
    return self;
}


- (id)itemAtIndex:(NSInteger)index
{
    if (index >= [self.items count] || index < 0)
        return nil;
    NSArray *tmpItems = [self.items copy];
    return tmpItems[index];
    
    return self.items[index];
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self itemAtIndex:indexPath.row];
}

- (void)resetItems:(NSArray *)anItems
    cellIdentifier:(NSString *)aCellIdentifier
configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock
{
    [self resetItems:anItems];
    self.cellIdentifier = aCellIdentifier;
    self.configureCellBlock = aConfigureCellBlock;
}

- (void)resetellIdentifier:(NSString *)aCellIdentifier
configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock
{
    self.cellIdentifier = aCellIdentifier;
    self.configureCellBlock = aConfigureCellBlock;
}

- (void)resetellIdentifier:(NSString *)aCellIdentifier
{
    self.cellIdentifier = aCellIdentifier;
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
    if (anItems)
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

- (void)dealloc
{
    [self.items removeAllObjects], self.items = nil;
    self.configureCellBlock = nil;
    self.cellIdentifier = nil;
}


#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier forIndexPath:indexPath];
    id item = [self itemAtIndexPath:indexPath];
    self.configureCellBlock(cell, item);
    return cell;
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.items.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellIdentifier forIndexPath:indexPath];
    id item = [self itemAtIndexPath:indexPath];
    self.configureCellBlock(cell, item);
    return cell;
}
@end
