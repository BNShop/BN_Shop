//
//  BN_ShopOrderCartItemModel.h
//  BN_Shop
//
//  Created by Liya on 2016/12/3.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BN_ShopOrderCartItemModel : NSObject
@property (nonatomic, assign) int goodsId;
@property (nonatomic, assign) int fk_t_bo_user_id;
@property (nonatomic, assign) int free_shipping_status;
@property (nonatomic, assign) int free_shipping_amount;
@property (nonatomic, assign) int shopping_cart_id;
@property (nonatomic, assign) int num;
@property (nonatomic, copy) NSString *standard;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pic_url;
@property (nonatomic, copy) NSString *front_price;
@property (nonatomic, copy) NSString *real_price;

@property (nonatomic, copy) NSString *goods_name;
@property (nonatomic, assign) int goods_num;

@end
