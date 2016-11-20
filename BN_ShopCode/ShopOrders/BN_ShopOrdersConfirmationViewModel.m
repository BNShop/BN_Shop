//
//  BN_ShopOrdersConfirmationViewModel.m
//  BN_Shop
//
//  Created by Liya on 16/11/14.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopOrdersConfirmationViewModel.h"

@interface BN_ShopOrdersConfirmationViewModel ()

@property (nonatomic, strong) TableDataSource *dataSource;

@end

@implementation BN_ShopOrdersConfirmationViewModel

- (TableDataSource *)getSectionDataSourceWith:(NSArray *)items cellIdentifier:(NSString *)cellIdentifier configureCellBlock:(TableViewCellConfigureBlock)configureCellBlock {
    self.dataSource = [[TableDataSource alloc] initWithItems:items cellIdentifier:cellIdentifier configureCellBlock:configureCellBlock];
    return _dataSource;
}

- (void)addDataSourceWith:(NSArray *)items {
    [self.dataSource addItems:items];
}

- (void)setIntegral:(NSString *)integral {
    _integral = integral;
    CGFloat integralTipsF = [self.integral floatValue] / 100.0;
    self.integralprice = [NSString stringWithFormat:@"%.2f", integralTipsF];
}

- (NSString *)realPrice {
    CGFloat retailPriceF = [self.retailPrice floatValue];
    CGFloat integralpriceF = [self.integralprice floatValue];
    CGFloat freightF = [self.freight floatValue];
    CGFloat realPriceF = retailPriceF - (self.deduction ? integralpriceF : 0) + freightF;
    return [NSString stringWithFormat:@"¥%.2f", realPriceF];
}

- (NSString *)integralDeductionTips {
    return [NSString stringWithFormat:@"%@%@%@¥%@", TEXT(@"可用"), self.integral, TEXT(@"抵扣"), self.integralprice];
}

- (NSString *)retailPriceTips {
    return [NSString stringWithFormat:@"¥%@", self.retailPrice];
}

- (NSString *)integralpriceTips {
    if (self.isDeduction) {
        return [NSString stringWithFormat:@"-¥%@", self.integralprice];
    } else {
        return [NSString stringWithFormat:@"-¥%.2f", 0.0];
    }
}

- (NSString *)freightTips {
    return [NSString stringWithFormat:@"+¥%@", self.freight];
}

@end
