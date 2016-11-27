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

@property (nonatomic, copy) NSString *goodsName;//商品名
@property (nonatomic, assign) long priceTagId;//价格标签
@property (nonatomic, assign) long suitTagId;//适合人群
@property (nonatomic, assign) long brandTagId;//品牌
@property (nonatomic, assign) long categoryId;//二级分类Id

- (void)getGoodsClearData:(BOOL)clear;

- (TableDataSource *)getDataSourceWith:(NSString *)cellIdentifier configureCellBlock:(TableViewCellConfigureBlock)configureCellBlock;
- (void)addDataSourceWith:(NSArray *)items;

- (void)setOrderWith:(NSInteger)radioIndex;
- (BOOL)isDesc;
- (NSString *)total_commentStr:(int)total_comment;
@end
