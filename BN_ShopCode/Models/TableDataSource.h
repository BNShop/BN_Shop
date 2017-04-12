//
//  TableDataSource.h
//  BN_Shop
//
//  Created by Liya on 16/11/12.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableViewCellConfigureBlock.h"

@interface TableDataSource : NSObject<UICollectionViewDataSource, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *items;

- (id)initWithItems:(NSArray *)anItems
     cellIdentifier:(NSString *)aCellIdentifier
 configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock;

- (id)itemAtIndex:(NSInteger)index;
- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

- (void)resetItems:(NSArray *)anItems
    cellIdentifier:(NSString *)aCellIdentifier
configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock;
- (void)resetellIdentifier:(NSString *)aCellIdentifier
        configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock;
- (void)resetellIdentifier:(NSString *)aCellIdentifier;

- (void)resetItems:(NSArray *)anItems;
- (void)addItems:(NSArray *)anItems;
- (NSInteger)getItemsCount;
- (void)deleteItemWithObj:(id)obj;

@end
