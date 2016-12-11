//
//  BN_ShopHomeFlashSaleViewModel.h
//  BN_Shop
//
//  Created by Liya on 16/11/17.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BN_ShopHeader.h"

@interface BN_ShopFlashSaleModel : BN_BaseDataModel

@property (nonatomic, copy) NSString *real_price;//真实价格
@property (nonatomic, copy) NSString *front_price;//真实价格
@property (nonatomic, copy) NSString *pic_url;//图片地址
@property (nonatomic, copy) NSString *name;//商品名称
@property (nonatomic, assign) long goodsId;//商品Id
@property (nonatomic, copy) NSString *buying_start_time;//限时开始时间
@property (nonatomic, copy) NSString *buying_end_time;//限时结束时间
@property (nonatomic, assign) int timeleft;//剩余时间（秒）
@property (nonatomic, assign) int buying_state;//0:未开始 1:抢购中 2:已结束


@end

@interface BN_ShopHomeFlashSaleViewModel : NSObject

@property (nonatomic, strong) BN_ShopFlashSaleModel *flashSaleModel;
- (void)getFlashSaleData;
- (NSAttributedString *)priceAttri;
- (NSDate *)date;
- (NSString *)timeTitle;
- (UIColor *)timeColor;
@end
