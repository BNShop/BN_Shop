//
//  BN_ShopGoodModel.h
//  BN_Shop
//
//  Created by Liya on 2016/11/27.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BN_ShopGoodModel : NSObject
@property (nonatomic, assign) long goods_id;//商品主键
@property (nonatomic, copy) NSString *name;//商品名称
@property (nonatomic, copy) NSString *pic_url;//商品图片地址
@property (nonatomic, copy) NSString *front_price;//商品显示价格
@property (nonatomic, copy) NSString *real_price;//商品售价
@property (nonatomic, copy) NSString *buying_start_time;//限时抢购开始时间
@property (nonatomic, copy) NSString *buying_end_time;//限时抢购结束时间
@property (nonatomic, assign) int avail_buying_num;//可买数量
@property (nonatomic, assign) int out_buying_num;//已抢购数量
@property (nonatomic, assign) int total_comment;//评论数
@property (nonatomic, assign) long category_id;//long分类id
@property (nonatomic, copy) NSString *category_name;//String类名

@property (nonatomic, assign) long warn_id;//有值：已设置提醒，-1：没设置提醒
@property (nonatomic, copy) NSString *warntime;//提醒时间
@property (nonatomic, assign) int buying_state;//抢购状态0:未开始1:抢购中2:已结束
@property (nonatomic, assign) int timeleft;//剩余时间
- (NSDate *)date;//抢购时间点

@end
