//
//  BN_ShopGoodSpecialModel.h
//  BN_Shop
//
//  Created by Liya on 2016/11/29.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BN_ShopGoodSpecialModel : NSObject
@property (nonatomic, assign) long obj_id;//对应的对象ID 如类型是景点,则本ID为关联的景点id
@property (nonatomic, copy) NSString *title_display;//显示标题
@property (nonatomic, copy) NSString *vice_title_display;//副显示标题
@property (nonatomic, copy) NSString *image_url1;
@property (nonatomic, copy) NSString *image_url2;
@property (nonatomic, copy) NSString *content_display;//显示内容 富文本
@property (nonatomic, copy) NSString *real_price;//商品售价
@property (nonatomic, assign) int total_like;//点赞次数
@property (nonatomic, assign) NSString *pic_url;//物品的头像

- (NSAttributedString *)contentAttributed;
- (NSAttributedString *)priceAttributed;
- (NSString *)followStr;

@end
