//
//  BN_ShopOrdersConfirmationViewModel.h
//  BN_Shop
//
//  Created by Liya on 16/11/14.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableDataSource.h"
@interface BN_ShopOrdersConfirmationViewModel : NSObject

@property (nonatomic, strong, readonly) TableDataSource *dataSource;

@property (nonatomic, copy) NSString *retailPrice;//商品总额
@property (nonatomic, copy) NSString *integral;//积分
@property (nonatomic, copy) NSString *integralprice;//可用积分抵扣的钱
@property (nonatomic, assign, getter=isDeduction) BOOL deduction;//是否抵扣积分
@property (nonatomic, copy) NSString *freight; //运费


- (TableDataSource *)getSectionDataSourceWith:(NSArray *)items cellIdentifier:(NSString *)cellIdentifier configureCellBlock:(TableViewCellConfigureBlock)configureCellBlock;
- (void)addDataSourceWith:(NSArray *)items;

- (NSString *)realPrice;
- (NSString *)integralDeductionTips;
- (NSString *)retailPriceTips;
- (NSString *)integralpriceTips;
- (NSString *)freightTips;

@end
