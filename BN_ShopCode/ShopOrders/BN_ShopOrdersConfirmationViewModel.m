//
//  BN_ShopOrdersConfirmationViewModel.m
//  BN_Shop
//
//  Created by Liya on 16/11/14.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopOrdersConfirmationViewModel.h"
#import "NSString+Attributed.h"

@implementation BN_ShopConfirmOrderItemModel

- (void)setShoppingCartList:(NSArray<BN_ShopOrderCartItemModel *> *)shoppingCartList {
    _shoppingCartList = [BN_ShopOrderCartItemModel mj_objectArrayWithKeyValuesArray:shoppingCartList];
}

- (NSAttributedString *)totalPriceAttributed {
    NSString *num = [NSString stringWithFormat:@"共计%lu件商品 小计 ",(unsigned long) self.shoppingCartList.count];
    NSString *price = [NSString stringWithFormat:@"¥%@", self.total_price];
    
    NSString *total = [NSString stringWithFormat:@"%@%@", num, price];
    NSRange range = [total rangeOfString:price];
    return [total setColor:nil restColor:nil range:range];
}

- (NSString *)freightPriceStr {
    return [NSString stringWithFormat:@"¥%@", self.freight_price];
}


@end

@implementation BN_ShopConfirmOrderSectionModel
- (void)setRows:(NSMutableArray<BN_ShopConfirmOrderItemModel *> *)rows {
    _rows = [BN_ShopConfirmOrderItemModel mj_objectArrayWithKeyValuesArray:rows];
}
@end

@implementation BN_ShopConfirmOrderModel

- (void)setResultMap:(BN_ShopConfirmOrderSectionModel *)resultMap {
    _resultMap = [BN_ShopConfirmOrderSectionModel mj_objectWithKeyValues:resultMap];
}

- (void)setUserAddress:(BN_ShopUserAddressModel *)userAddress {
    _userAddress = [BN_ShopUserAddressModel mj_objectWithKeyValues:userAddress];
}

- (NSString *)vailableUseStr {
    return [NSString stringWithFormat:@"%@%@%@¥%@", TEXT(@"可用"), self.totalIntegral, TEXT(@"抵扣"), self.vailableUse];
}

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


- (NSString *)realNeedPayStr {
    
    if (self.userVailable) {
        float pay = [self.ordreModel.resultMap.real_need_pay floatValue];
        float vailable = [self.ordreModel.vailableUse floatValue];
        
        return [NSString stringWithFormat:@"¥%.2f", (pay-vailable)];
    }
    return [NSString stringWithFormat:@"¥%@", self.ordreModel.resultMap.real_need_pay];
    
}
//商品总额
- (NSString *)shopAcountStr {
    float pay = 0;
    for (BN_ShopConfirmOrderItemModel *item in self.ordreModel.resultMap.rows) {
        pay += [item.goods_amount floatValue];
    }
    return [NSString stringWithFormat:@"+¥%.2f", pay];
}
//运费
- (NSString *)shopFreightStr {
    float pay = 0;
    for (BN_ShopConfirmOrderItemModel *item in self.ordreModel.resultMap.rows) {
        pay += [item.freight_price floatValue];
    }
    return [NSString stringWithFormat:@"+¥%.2f", pay];
}
//积分抵扣
- (NSString *)shopVailableStr {
    if (self.userVailable) {
        return [NSString stringWithFormat:@"-¥%@", self.ordreModel.vailableUse];
    }
    return @"-¥0.00";
}


#pragma mark - 获取数据
- (void)getShoppingOrderConfirmationDetail:(void(^)())success failure:(void(^)(NSString *errorDescription))failure {
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    
    NSString *url = [NSString stringWithFormat:@"%@/mall/confirmOrder",BASEURL];
    if (self.goodsId > 0 && self.num > 0) {
        url = [NSString stringWithFormat:@"%@/mall/specialConfirmOrder",BASEURL];
        paraDic[@"goodsId"] = @(self.goodsId);
        paraDic[@"num"] = @(self.num);
    } else {
        NSString *shoppingCartIdStr = [self.shoppingCartIds stringByAppendingString:@","];;//	购物车ID，多个，逗号隔开
        NSString *numberStr = [self.numbers stringByAppendingString:@","];
        
        paraDic[@"shoppingCartIds"] = shoppingCartIdStr;
        paraDic[@"numbers"] = numberStr;
    }
    __weak typeof(self) temp = self;
    
    [[BC_ToolRequest sharedManager] POST:url parameters:paraDic success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSNumber *codeNumber = [dic objectForKey:@"code"];
        if (codeNumber.intValue != 0) {
            temp.ordreModel = [BN_ShopConfirmOrderModel mj_objectWithKeyValues:[dic objectForKey:@"result"]];
            temp.submenu = temp.ordreModel.resultMap.rows.count > 1;
            if (failure) {
                failure(errorStr);
            }
        } else {
            if (success) {
                success();
            }
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        if (failure) {
            failure([error errorDescription]);
        }
    }];
}
@end
