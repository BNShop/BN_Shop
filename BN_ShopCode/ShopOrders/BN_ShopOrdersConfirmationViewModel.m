//
//  BN_ShopOrdersConfirmationViewModel.m
//  BN_Shop
//
//  Created by Liya on 16/11/14.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopOrdersConfirmationViewModel.h"

@interface BN_ShopOrdersConfirmationViewModel ()

@end

@implementation BN_ShopOrdersConfirmationViewModel

- (SectionDataSource *)getSectionDataSourceWith:(NSString *)title items:(NSArray*)items cellIdentifier:(NSString *)cellIdentifier configureCellBlock:(TableViewCellConfigureBlock)configureCellBlock configureSectionBlock:(TableViewSectionConfigureBlock)configureSectionBlock {
    
    SectionDataSource *sectionDataSource = [[SectionDataSource alloc] initWithItems:items title:title];
    sectionDataSource.cellIdentifier = cellIdentifier;
    sectionDataSource.configureCellBlock = configureCellBlock;
    sectionDataSource.configureSectionBlock = configureSectionBlock;
    sectionDataSource.sectionIdentifier = nil;
    
    return sectionDataSource;
}

- (void)addDataSourceWith:(SectionDataSource *)sectionDataSource {
    if (!_dataSource) {
        _dataSource = [[MultipleSectionTableArraySource alloc] initWithSections:nil];
    }
    [_dataSource addSections:[NSArray arrayWithObject:sectionDataSource]];
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
