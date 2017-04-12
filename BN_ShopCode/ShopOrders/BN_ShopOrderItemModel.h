//
//  BN_ShopOrderItemModel.h
//  BN_Shop
//
//  Created by Liya on 2016/12/3.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BN_ShopOrderItemModel : NSObject
@property (nonatomic, assign) int goods_num;
@property (nonatomic, copy) NSString *goods_name;
@property (nonatomic, copy) NSString *pic_url;
@property (nonatomic, copy) NSString *front_price;//12.00,
@property (nonatomic, copy) NSString *real_price;//2.00,
@property (nonatomic, copy) NSString *standard;//12",
@property (nonatomic, assign) int goods_id;//
@property (nonatomic, assign) int order_id;
@property (nonatomic, copy) NSString *order_no;//订单编号
@property (nonatomic, copy) NSString *order_state_name;//
@end
