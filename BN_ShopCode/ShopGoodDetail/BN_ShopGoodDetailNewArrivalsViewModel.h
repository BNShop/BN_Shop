//
//  BN_ShopGoodDetailNewArrivalsViewModel.h
//  BN_Shop
//
//  Created by Liya on 2016/11/21.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableDataSource.h"
#import "BN_ShopHeader.h"

@interface BN_ShopGoodDetailNewArrivalsModel : NSObject

@property (nonatomic, assign) long goods_id;//商品主键
@property (nonatomic, copy) NSString *name;//商品名称
@property (nonatomic, copy) NSString *pic_url;//商品图片地址
@property (nonatomic, copy) NSString *front_price;//商品显示价格
@property (nonatomic, copy) NSString *real_price;//商品售价
@property (nonatomic, copy) NSString *standard;//规格


@end

@interface BN_ShopGoodDetailNewArrivalsViewModel : NSObject

@property (nonatomic, strong) NSMutableArray<BN_ShopGoodDetailNewArrivalsModel*> *arrivals;
@property (nonatomic, strong) TableDataSource *dataSource;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;

- (void)getNewArrivalsClearData:(BOOL)clear goodsId:(long)goodsId;

@end
