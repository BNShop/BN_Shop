//
//  BN_ShopGoodSpecialModel.h
//  BN_Shop
//
//  Created by Liya on 2016/11/29.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BN_ShopGoodSpecialModel : NSObject
@property (nonatomic, assign) long goods_id;//Long商品主键
@property (nonatomic, copy) NSString *name;//int商品名称
@property (nonatomic, copy) NSString *pic_url;//String商品图片地址
@property (nonatomic, copy) NSString *vice_pic_url;//String副商品图片地址
@property (nonatomic, copy) NSString *front_price;//String商品显示价格
@property (nonatomic, copy) NSString *real_price;//String商品售价
@property (nonatomic, copy) NSString *buying_start_time;//String限时抢购开始时间
@property (nonatomic, copy) NSString *buying_end_time;//String限时抢购结束时间
@property (nonatomic, assign) int avail_buying_num;//int可买数量
@property (nonatomic, assign) int out_buying_num;//int已抢购数量
@property (nonatomic, assign) long category_id;//long分类id
@property (nonatomic, copy) NSString *category_name;//String类名
@property (nonatomic, copy) NSString *title_display;//String显示标题
@property (nonatomic, copy) NSString *vice_title_display;//String副标题
@property (nonatomic, copy) NSString *content_display;//String显示内容
@property (nonatomic, assign) int total_like;//int点赞数

@end
