//
//  BN_ShopSorterViewModel.h
//  BN_Shop
//
//  Created by Liya on 16/11/13.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableDataSource.h"

@interface BN_ShopSorterViewModel : NSObject

@property (nonatomic, assign) NSInteger selectionIndex;
@property (nonatomic, strong, readonly) TableDataSource *titleDataSource;
@property (nonatomic, strong, readonly) TableDataSource *selectionDataSource;

- (TableDataSource *)getTitleDataSourceWith:(NSArray *)titles
                             cellIdentifier:(NSString *)aCellIdentifier
                         configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock;
- (TableDataSource *)getSectionDataSourceWith:(NSArray *)sections
                               cellIdentifier:(NSString *)aCellIdentifier
                           configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock;

@end

