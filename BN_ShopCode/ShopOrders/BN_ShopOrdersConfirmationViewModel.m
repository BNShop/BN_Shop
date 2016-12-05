//
//  BN_ShopOrdersConfirmationViewModel.m
//  BN_Shop
//
//  Created by Liya on 16/11/14.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopOrdersConfirmationViewModel.h"
#import "NSString+Attributed.h"
#import "NSError+Description.h"
#import "BN_ShopGoodModel.h"


@implementation BN_ShopConfirmOrderItemModel

- (void)setShoppingCartList:(NSArray<BN_ShopOrderCartItemModel *> *)shoppingCartList {
    _shoppingCartList = [BN_ShopOrderCartItemModel mj_objectArrayWithKeyValuesArray:shoppingCartList];
}

- (NSAttributedString *)totalPriceAttributed {
    NSString *num = [NSString stringWithFormat:@"共计%lu件商品 小计 ",(unsigned long) self.shoppingCartList.count];
    NSString *price = [NSString stringWithFormat:@"¥%@", self.total_price];
    
    NSString *total = [NSString stringWithFormat:@"%@%@", num, price];
    NSRange range = [total rangeOfString:price];
    return [total setColor:ColorRed restColor:ColorLightGray range:range];
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
    return [NSString stringWithFormat:@"%@%d%@¥%@", TEXT(@"可用"), self.totalIntegral, TEXT(@"抵扣"), self.availableUse];
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
    float pay = [self.ordreModel.resultMap.real_need_pay floatValue];
    if (self.userVailable) {
        
        float vailable = [self.ordreModel.availableUse floatValue];
        
        return [NSString stringWithFormat:@"¥%.2f", (pay-vailable)];
    }
    return [NSString stringWithFormat:@"¥%.2f", pay];
    
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
        return [NSString stringWithFormat:@"-¥%@", self.ordreModel.availableUse];
    }
    return @"-¥0.00";
}

#pragma mark - 获取数据
- (void)getShoppingOrderConfirmationDetail:(void(^)())success failure:(void(^)(NSString *errorDescription))failure {
    NSMutableDictionary *paraDic = nil;//[NSMutableDictionary dictionary];
    
    NSString *url = nil;// [NSString stringWithFormat:@"%@/mall/confirmOrder",BASEURL];
    if (self.goodsId > 0 && self.num > 0) {
        url = [NSString stringWithFormat:@"%@/mall/specialConfirmOrder?goodsId=%ld&num=%d",BASEURL, self.goodsId, self.num];
        paraDic[@"goodsId"] = @(self.goodsId);
        paraDic[@"num"] = @(self.num);
    } else {

        url = [NSString stringWithFormat:@"%@/mall/confirmOrder?shoppingCartIds=%@&numbers=%@",BASEURL, self.shoppingCartIds, self.numbers];
        paraDic[@"shoppingCartIds"] = self.shoppingCartIds;
        paraDic[@"numbers"] = self.numbers;
    }
    __weak typeof(self) temp = self;
    
    [[BC_ToolRequest sharedManager] GET:url parameters:paraDic success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSNumber *codeNumber = [dic objectForKey:@"code"];
        if (codeNumber.intValue != 0) {
            
            if (failure) {
                NSString *errorStr = [dic objectForKey:@"remark"];
                failure(errorStr);
            }
        } else {
            temp.ordreModel = [BN_ShopConfirmOrderModel mj_objectWithKeyValues:[dic objectForKey:@"result"]];
            temp.submenu = temp.ordreModel.resultMap.rows.count > 1;
            NSDictionary *resultMap = [[dic objectForKey:@"result"] objectForKey:@"resultMap"];
            NSDictionary *resultMap0 = [resultMap objectForKey:@"resultMap"];
            NSDictionary *goodsDetail = [resultMap0 objectForKey:@"goodsDetail"];
            if (temp.goodsId > 0) {
                temp.ordreModel.resultMap.rows = [NSMutableArray array];
                BN_ShopConfirmOrderItemModel *itemModel = [BN_ShopConfirmOrderItemModel mj_objectWithKeyValues:resultMap0];
                [temp.ordreModel.resultMap.rows addObject:itemModel];
                
                itemModel.goodDetailModel = [BN_ShopGoodSimpleDetailModel mj_objectWithKeyValues:goodsDetail];
                
                NSMutableArray *tmplist = [NSMutableArray array];
                BN_ShopOrderCartItemModel *cartItemModel = [[BN_ShopOrderCartItemModel alloc] init];
                [tmplist addObject:cartItemModel];
                cartItemModel.goodsId = temp.goodsId;
                cartItemModel.fk_t_bo_user_id = [itemModel.boUserId intValue];
                cartItemModel.real_price = itemModel.goodDetailModel.real_price;
                cartItemModel.name = itemModel.goodDetailModel.name;
                cartItemModel.pic_url = itemModel.goodDetailModel.pic_url;
                cartItemModel.num = temp.num;
                cartItemModel.standard = itemModel.goodDetailModel.standard;
                itemModel.shoppingCartList = tmplist;
            }
            
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

//http://xxx.xxx.xxx/mall/confirmOrder（POST）
- (void)getShoppingOrderDetail:(void(^)(NSArray *orderIds))success failure:(void(^)(NSString *errorDescription))failure {
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    
    if (self.ordreModel.userAddress.address_id) {
        paraDic[@"addressId"] = @(self.ordreModel.userAddress.address_id);
    }
    paraDic[@"integral"] = self.ordreModel.availableUse;

    if (self.userVailable) {
        paraDic[@"isUseIntegral"] = @(1);
    } else {
        paraDic[@"isUseIntegral"] = @(0);
    }
    
    paraDic[@"real_need_pay"] = self.ordreModel.resultMap.real_need_pay;
    
    // Model array -> JSON array
    if (self.goodsId > 0 && self.num > 0) {
        BN_ShopConfirmOrderItemModel *item = (BN_ShopConfirmOrderItemModel *)self.ordreModel.resultMap.rows.firstObject;
        NSDictionary *goodDic = @{@"num":@(self.num), @"goodsId":@(self.goodsId)};
        NSDictionary *rowItemDic = @{@"goods":@[goodDic], @"boUserId":@([item.boUserId integerValue]), @"freight_price":item.freight_price, @"total_price":item.goods_amount};
        
        paraDic[@"rows"] = @[rowItemDic];
    } else {
        paraDic[@"shoppingCartIds"] = self.shoppingCartIds;
        paraDic[@"numbers"] = self.numbers;
        
        NSMutableArray *rowDicS = [NSMutableArray array];
        for (BN_ShopConfirmOrderItemModel *itemModel in self.ordreModel.resultMap.rows) {
            NSMutableDictionary *itemDic = [NSMutableDictionary dictionary];
            itemDic[@"total_price"] = itemModel.goods_amount;
            itemDic[@"boUserId"] = @([itemModel.boUserId integerValue]);
            itemDic[@"freight_price"] = itemModel.freight_price;
            
            NSMutableArray *goods = [NSMutableArray array];
            for (BN_ShopOrderCartItemModel *cartItem in itemModel.shoppingCartList) {
                NSMutableDictionary *cartDic = [NSMutableDictionary dictionary];
                cartDic[@"goodsId"] = @(cartItem.goodsId);
                cartDic[@"num"] = @(cartItem.num);
                [goods addObject:cartDic];
            }
            itemDic[@"goods"] = goods;
            [rowDicS addObject:itemDic];
        }
        
        paraDic[@"rows"] = rowDicS;
    }
    NSLog(@"jsonstr = %@", paraDic[@"rows"]);
    NSString *url = [NSString stringWithFormat:@"%@/mall/confirmOrder",BASEURL];
    [[BC_ToolRequest sharedManager] POST:url parameters:paraDic success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        if ([responseObject isKindOfClass:[NSData class]]) {
            dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        }
        NSNumber *codeNumber = [dic objectForKey:@"code"];
        if (codeNumber.intValue != 0) {
            NSString *errorStr = [dic objectForKey:@"remark"];
            if (failure) {
                failure(errorStr);
            }
        } else {
            if (success) {
                success((dic[@"result"])[@"orderIds"]);
            }
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        if (failure) {
            failure([error errorDescription]);
        }
    }];
}

@end
