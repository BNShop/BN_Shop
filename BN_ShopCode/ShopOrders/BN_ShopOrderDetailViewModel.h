//
//  BN_ShopOrderDetailViewModel.h
//  BN_Shop
//
//  Created by Liya on 2016/12/3.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BN_ShopUserAddressModel.h"
#import "BN_ShopOrderItemProtocol.h"
#import "BN_ShopOrderItemModel.h"
#import "TableDataSource.h"
typedef NS_ENUM(NSUInteger, BN_ShopOrderState) {
    BN_ShopOrderState_Pay = 0,
    BN_ShopOrderState_Take = 1,
    BN_ShopOrderState_Recommend = 2,
    BN_ShopOrderState_Finish = 3
};



@interface BN_ShopOrderDetailModel : NSObject

@property (nonatomic, strong) NSMutableArray *goodsList;
@property (nonatomic, assign) int use_integral;//是否使用积分1：是 0：否
@property (nonatomic, copy) NSString *contact_person_name;//联系人
@property (nonatomic, copy) NSString *pay_amount;//实付金额
@property (nonatomic, copy) NSString *order_state_name;//订单状态名
@property (nonatomic, copy) NSString *contact_person_phone_num;//联系电话
@property (nonatomic, copy) NSString *freight_amount;//运费
@property (nonatomic, copy) NSString *courier_no;//快递单号
@property (nonatomic, copy) NSString *order_id;//订单ID
@property (nonatomic, copy) NSString *goods_amount;//商品总金额
@property (nonatomic, copy) NSString *city;//城市
@property (nonatomic, copy) NSString *province;//省
@property (nonatomic, copy) NSString *district;//String区
@property (nonatomic, assign) int pay_type;//1 微信支付2 支付宝支付3 平安银行支付
@property (nonatomic, copy) NSString *detailed_addr;//详细地址
@property (nonatomic, copy) NSString *create_time;//String下单时间
@property (nonatomic, copy) NSString *integral_amount;//积分金额
@property (nonatomic, copy) NSString *comment_state_name;//评论状态名
@property (nonatomic, copy) NSString *saleafter_state_name;//售后状态名
@property (nonatomic, assign) int pay_type;//int 1 微信支付 2 支付宝支付 3 平安银行支付

- (int)orderState;//0 代之父 1代收货 2代评价 3已完成
- (int)saleafter;//售后状态 0求租 1等待 2 万次
- (NSString *)pay_typeName;

@end

@interface BN_ShopOrderDetailViewModel : NSObject
@property (nonatomic, copy) NSString *order_id;//订单ID

@property (nonatomic, strong) BN_ShopUserAddressModel *userProfile;
@property (nonatomic, strong) BN_ShopOrderDetailModel *detailModel;

@property (nonatomic, strong) TableDataSource *dataSource;

- (void)getShoppingOrderDetail:(void(^)())success failure:(void(^)(NSString *errorDescription))failure;


@end
