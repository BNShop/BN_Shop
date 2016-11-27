//
//  BN_ShopListViewModel.h
//  BN_Shop
//
//  Created by Liya on 16/11/15.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableDataSource.h"
#import "BN_ShopGoodModel.h"

@interface BN_ShopListViewModel : NSObject

@property (nonatomic, strong, readonly) TableDataSource *dataSource;
@property (nonatomic, strong) NSMutableArray <BN_ShopGoodModel*> *goods;
@property (nonatomic, assign) BOOL isHorizontalCell;

- (void)getGoodsClearData:(BOOL)clear;

- (TableDataSource *)getDataSourceWith:(NSString *)cellIdentifier configureCellBlock:(TableViewCellConfigureBlock)configureCellBlock;
- (void)addDataSourceWith:(NSArray *)items;

- (void)setOrderWith:(NSInteger)radioIndex;
- (BOOL)isDesc;
@end
