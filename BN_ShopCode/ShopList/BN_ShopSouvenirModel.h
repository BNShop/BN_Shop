//
//  BN_ShopSouvenirModel.h
//  BN_Shop
//
//  Created by Liya on 2016/11/30.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BN_ShopSouvenirGoodModel : NSObject
@property (nonatomic, assign) long goods_id;//商品id
@property (nonatomic, copy) NSString *name;//商品名
@property (nonatomic, copy) NSString *pic_url;//商品封面
@property (nonatomic, copy) NSString *front_price;//显示价格
@property (nonatomic, copy) NSString *real_price;//真实价格
@property (nonatomic, copy) NSString *buying_start_time;//抢购开始时间
@property (nonatomic, copy) NSString *buying_end_time;//抢购结束时间
@property (nonatomic, copy) NSString *avail_buying_num;//可抢购数量
@property (nonatomic, copy) NSString *out_buying_num;//已抢购数量
@property (nonatomic, copy) NSString *category_name;//分类名
@property (nonatomic, copy) NSString *category_id;//分类id
@end

@interface BN_ShopSouvenirModel : NSObject

@property (nonatomic, assign) long category_id;//分类主键
@property (nonatomic, copy) NSString *name;//分类名称
@property (nonatomic, strong) NSMutableArray<BN_ShopSouvenirGoodModel*> *goodsList;//
@property (nonatomic, copy) NSString *pic_horizontal_url;//横图
@property (nonatomic, assign) int obj_type;//4  伴手礼 14 伴手礼专题
@property (nonatomic, assign) long obj_id;//对象id


@end
