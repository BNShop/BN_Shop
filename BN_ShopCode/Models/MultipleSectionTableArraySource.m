//
//  MultipleSectionTableArraySource.m
//  TVPhone
//
//  Created by Liya on 15/11/9.
//  Copyright (c) 2015年 Liya. All rights reserved.
//

#import "MultipleSectionTableArraySource.h"
#import "UITableViewCell+NIB.h"
#import "NSArray+BlocksKit.h"

@interface MultipleSectionTableArraySource()
{
    BOOL isNoRegisterForCell;
}


@end

@implementation MultipleSectionTableArraySource

- (id)initWithSections:(NSArray *)anSections
{
    self = [super init];
    if (self) {
        [self resetSections:anSections];
    }
    return self;
}


- (id)sectionAtIndex:(NSInteger)index
{
    if (index >= [self.sections count] || index < 0)
        return nil;
    NSArray *tmpItems = [self.sections copy];
    return tmpItems[index];
}

- (id)sectionAtIndexPath:(NSIndexPath *)indexPath
{
    return [self sectionAtIndex:indexPath.section];
}

- (id)itemAtIndexTagged:(id)tagged {
    NSArray *tmpItems = [self.sections copy];
    return [tmpItems bk_match:^BOOL(id obj) {
        return [obj isEqual:tagged];
    }];
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    SectionDataSource *source = [self sectionAtIndexPath:indexPath];
    return [source itemAtIndexPath:indexPath];
}

- (void)itemDeleteAtIndexPath:(NSIndexPath *)indexPath
{
    SectionDataSource *source = [self sectionAtIndexPath:indexPath];
    return [source itemDelIndexPath:indexPath];
}


- (void)resetSections:(NSArray *)anSections
{
    if (anSections)
        self.sections = [NSMutableArray arrayWithArray:anSections];
    else
        self.sections = nil;
}

- (void)addSections:(NSArray *)anSections
{
    if (anSections)
    {
        if (!self.sections)
            self.sections = [NSMutableArray arrayWithArray:anSections];
        else
        {
            @synchronized(_sections)
            {
                [_sections addObjectsFromArray:anSections];
            }
        }
    }
}

- (NSInteger)getSectionCount
{
    return [_sections count];
}


- (NSInteger)getItemCountWith:(NSInteger)index
{
    SectionDataSource *source = [self sectionAtIndex:index];
    return [source getItemsCount];
}

- (NSInteger)getItemCountWithIndexPath:(NSIndexPath *)indexPath
{
    return [self getItemCountWith:indexPath.section];
}


- (void)dealloc
{
    [self.sections removeAllObjects], self.sections = nil;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self getItemCountWith:section];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SectionDataSource *section = [self sectionAtIndex:indexPath.section];
    id item = [section itemAtIndexPath:indexPath];
    UITableViewCell *cell = nil;
    if (!isNoRegisterForCell)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:section.cellIdentifier forIndexPath:indexPath];
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:section.cellIdentifier];
        if (cell == nil)
        {
            if (section.isCellNib)
            {
                cell = [NSClassFromString(section.cellClassName) loadFromNibWith:section.cellIdentifier];
            }
            else
            {
                cell = [[NSClassFromString(section.cellClassName) alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:section.cellIdentifier];
            }
        }
    }
    
    section.configureCellBlock(cell, item);
    
    return cell;
}


- (void)setNoRegisterForCellWith:(BOOL)isNoRegister
{
    isNoRegisterForCell = isNoRegister;;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.sections count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self getItemCountWith:section];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SectionDataSource *section = [self sectionAtIndex:indexPath.section];
    id item = [section itemAtIndexPath:indexPath];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:section.cellIdentifier forIndexPath:indexPath];
    section.configureCellBlock(cell, item);
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    SectionDataSource *section = [self sectionAtIndex:indexPath.section];
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:section.sectionIdentifier forIndexPath:indexPath];
    section.configureSectionBlock(view, section, kind, indexPath);
    return view;
}
@end

