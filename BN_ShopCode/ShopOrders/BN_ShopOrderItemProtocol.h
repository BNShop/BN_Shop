//
//  BN_ShopOrderItemProtocol.h
//  BN_Shop
//
//  Created by Liya on 2016/12/3.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BN_ShopOrderItemProtocol <NSObject>
@property (nonatomic, copy) NSString *goods_name;
@property (nonatomic, copy) NSString *pic_url;
@property (nonatomic, copy) NSString *real_price;//2.00,
@property (nonatomic, copy) NSString *standard;//12",
@property (nonatomic, assign) int goods_num;
@end
