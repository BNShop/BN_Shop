//
//  BN_ShopSorterViewModel.h
//  BN_Shop
//
//  Created by Liya on 16/11/13.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableDataSource.h"
#import "BN_ShopCategoryModel.h"
#import "BN_ShopHeader.h"

@interface BN_ShopSorterViewModel : NSObject

@property (nonatomic, assign) long curCategoryId;
@property (nonatomic, strong) NSMutableArray *categories;
@property (nonatomic, strong, readonly) TableDataSource *titleDataSource;
@property (nonatomic, strong, readonly) TableDataSource *secondCategoryDataSource;

- (TableDataSource *)getTitleDataSourceWith:(NSArray *)titles
                             cellIdentifier:(NSString *)aCellIdentifier
                         configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock;
- (TableDataSource *)getSecondDataSourceWith:(NSArray *)items
                               cellIdentifier:(NSString *)aCellIdentifier
                           configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock;
- (TableDataSource *)getSecondDataSourceWith:(NSArray *)items;

- (void)getCategories;
- (void)getSecondCategories:(BN_ShopCategoryModel *)categoryModel;
@end

