//
//  BN_ShopListViewModel.m
//  BN_Shop
//
//  Created by Liya on 16/11/15.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopListViewModel.h"

@interface BN_ShopListViewModel ()
@property (nonatomic, strong) TableDataSource *dataSource;
//排序的情况选择
@property (nonatomic, copy) NSString *order;
@property (nonatomic, copy) NSString *sort;

@end

static NSString * const BN_ShopListSortDesc = @"desc";
static NSString * const BN_ShopListSortAsc = @"asc";

static NSString * const BN_ShopListSortOrderPrice = @"real_price";
static NSString * const BN_ShopListSortOrderSales = @"sale";
static NSString * const BN_ShopListSortOrderComposite = @"composite";


@implementation BN_ShopListViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.order = BN_ShopListSortOrderComposite;
        self.sort = BN_ShopListSortDesc;
    }
    return self;
}

- (TableDataSource *)getSectionDataSourceWith:(NSArray *)items cellIdentifier:(NSString *)cellIdentifier configureCellBlock:(TableViewCellConfigureBlock)configureCellBlock {
    self.dataSource = [[TableDataSource alloc] initWithItems:items cellIdentifier:cellIdentifier configureCellBlock:configureCellBlock];
    return _dataSource;
}

- (void)addDataSourceWith:(NSArray *)items {
    [self.dataSource addItems:items];
}


- (void)setOrderWith:(NSInteger)radioIndex{
    switch (radioIndex) {
        case 1:
            self.order = BN_ShopListSortOrderSales;//销量
            break;
        case 2:
            if ([self.order isEqualToString:BN_ShopListSortOrderPrice]) {//就等于价格，则进行反转
                if ([self isDesc]) {
                    self.sort = BN_ShopListSortAsc;
                } else {
                    self.sort = BN_ShopListSortDesc;
                }
            }
            self.order = BN_ShopListSortOrderPrice;
            break;
            
        default:
            self.order = BN_ShopListSortOrderComposite;//综合
            break;
    }
}

- (BOOL)isDesc {
    return [self.sort isEqualToString:BN_ShopListSortDesc];
}

#pragma mark - ui configuration


@end
