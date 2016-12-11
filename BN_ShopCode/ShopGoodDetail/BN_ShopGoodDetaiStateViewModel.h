//
//  BN_ShopGoodDetaiStateViewModel.h
//  BN_Shop
//
//  Created by Liya on 2016/11/20.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BN_GoodStateHeader.h"
#import "BN_ShopHeader.h"

@interface BN_ShopGoodSimpleDetailModel : NSObject

@property (nonatomic, assign) long goosd_id;//商品主键
@property (nonatomic, copy) NSString *name;//商品名称
@property (nonatomic, copy) NSString *pic_url;//商品图片地址
@property (nonatomic, copy) NSString *front_price;//商品显示价格
@property (nonatomic, copy) NSString *real_price;//商品售价
@property (nonatomic, copy) NSString *buying_start_time;//限时抢购开始时间
@property (nonatomic, copy) NSString *buying_end_time;//限时抢购结束时间
@property (nonatomic, assign) int avail_buying_num;//可买数量
@property (nonatomic, assign) int out_buying_num;//已抢购数量
@property (nonatomic, copy) NSString *goodDescription;//描述
@property (nonatomic, assign) int total_comment;//评论数
@property (nonatomic, assign) int total_like;//关注人数
@property (nonatomic, assign) int total_collected;//收藏人数
@property (nonatomic, copy) NSString *standard;//规格
@property (nonatomic, copy) NSString *shop_name;//供应商名称
@property (nonatomic, copy) NSString *shop_logo;//供应商店铺LOGO
@property (nonatomic, copy) NSString *shipping_amount;//供应商店铺包邮下限
@property (nonatomic, copy) NSString *free_shipping_amount;//供应商默认邮费
@property (nonatomic, assign) int free_shipping_status;//0 不包邮1  全场包邮2  满包邮
@property (nonatomic, assign) int buying_state;//0:未开始1:抢购中2:已结束
@property (nonatomic, assign) int avg_score;//平均评价
@property (nonatomic, copy) NSString *given_integral;//赠送积分数
@property (nonatomic, assign) int type;//1:普通商2:限时商品
@property (nonatomic, assign) int is_collect;//是否收藏了
@property (nonatomic, assign) int warn_id;//是否设置提醒的id



@end


@interface BN_ShopGoodDetaiStateViewModel : BN_BaseDataModel
@property (nonatomic, strong) BN_ShopGoodSimpleDetailModel *simpleDetailModel;

- (void)getSimpleDetailDataWith:(long)goodsId;
- (void)addShoppingCartWith:(long)goodsId num:(int)num success:(void(^)())success failure:(void(^)(NSString *errorDescription))failure;

- (NSAttributedString *)frontPriceAttrStr;
- (NSString *)realPriceStr;
- (NSString *)followNumStr;
- (NSString *)commentNumStr;
- (NSString *)saleNumStr;
- (NSString *)residueNumStr;
- (GoodDetaiStateType)state;//0 1 2
- (NSDate *)date;
- (NSString *)tips;

- (NSString *)freeShippingStatus;
- (NSString *)pointStr;

@end
