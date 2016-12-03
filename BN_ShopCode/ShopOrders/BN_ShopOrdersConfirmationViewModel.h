//
//  BN_ShopOrdersConfirmationViewModel.h
//  BN_Shop
//
//  Created by Liya on 16/11/14.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MultipleSectionTableArraySource.h"
#import "BN_ShopOrderCartItemModel.h"
#import "BN_ShopUserAddressModel.h"
#import "BN_ShopGoodDetaiStateViewModel.h"

@interface BN_ShopConfirmOrderItemModel : NSObject
@property (nonatomic, strong) NSArray<BN_ShopOrderCartItemModel*> *shoppingCartList;
@property (nonatomic, copy) NSString *freight_price;//yunfei
@property (nonatomic, copy) NSString *total_price;//这段实际支付
@property (nonatomic, copy) NSString *boUserId;
@property (nonatomic, copy) NSString *goods_amount;//商品总金额
@property (nonatomic, strong) BN_ShopGoodSimpleDetailModel *goodDetailModel;

- (NSAttributedString *)totalPriceAttributed;
- (NSString *)freightPriceStr;

@end

@interface BN_ShopConfirmOrderSectionModel : NSObject
@property (nonatomic, strong) NSMutableArray<BN_ShopConfirmOrderItemModel*> *rows;
@property (nonatomic, copy) NSString *real_need_pay;//需实际支付
@end

@interface BN_ShopConfirmOrderModel : NSObject

@property (nonatomic, strong) BN_ShopUserAddressModel *userAddress;
@property (nonatomic, copy) NSString *availableUse;//可用积分抵扣的钱
@property (nonatomic, assign) int totalIntegral;//可用积分
@property (nonatomic, strong) BN_ShopConfirmOrderSectionModel *resultMap;

- (NSString *)vailableUseStr;

@end

@interface BN_ShopOrdersConfirmationViewModel : NSObject

@property (nonatomic, copy) NSString *shoppingCartIds;//	购物车ID，多个，逗号隔开
@property (nonatomic, copy) NSString *numbers;

@property (nonatomic, assign) long goodsId;//限时抢购
@property (nonatomic, assign) int num;


@property (nonatomic, strong)  MultipleSectionTableArraySource *dataSource;
@property (nonatomic, strong) BN_ShopConfirmOrderModel *ordreModel;


@property (nonatomic, assign) BOOL userVailable;//shifou使用积分
@property (nonatomic, assign) BOOL submenu;//是否分单

- (void)getShoppingOrderConfirmationDetail:(void(^)())success failure:(void(^)(NSString *errorDescription))failure;
- (void)getShoppingOrderDetail:(void(^)())success failure:(void(^)(NSString *errorDescription))failure;


- (SectionDataSource *)getSectionDataSourceWith:(NSString *)title items:(NSArray*)items cellIdentifier:(NSString *)cellIdentifier configureCellBlock:(TableViewCellConfigureBlock)configureCellBlock configureSectionBlock:(TableViewSectionConfigureBlock)configureSectionBlock;
- (void)addDataSourceWith:(SectionDataSource *)sectionDataSource;

- (NSString *)realNeedPayStr;
//商品总额
- (NSString *)shopAcountStr;
//运费
- (NSString *)shopFreightStr;
//积分抵扣
- (NSString *)shopVailableStr;
@end
