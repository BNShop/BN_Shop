//
//  BN_ShopListViewModel.h
//  BN_Shop
//
//  Created by Liya on 16/11/15.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableDataSource.h"

@interface BN_ShopListViewModel : NSObject

@property (nonatomic, strong, readonly) TableDataSource *dataSource;
@property (nonatomic, assign) BOOL isHorizontalCell;



- (TableDataSource *)getSectionDataSourceWith:(NSArray *)items cellIdentifier:(NSString *)cellIdentifier configureCellBlock:(TableViewCellConfigureBlock)configureCellBlock;
- (void)addDataSourceWith:(NSArray *)items;

- (void)setOrderWith:(NSInteger)radioIndex;
- (BOOL)isDesc;
@end
