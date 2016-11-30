//
//  BN_ShoppingCartViewModel.h
//  BN_Shop
//
//  Created by Liya on 16/11/13.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MultipleSectionTableArraySource.h"
#import "BN_ShoppingCartItemProtocol.h"

@interface BN_ShoppingCartItemModel : NSObject

@property (nonatomic, assign) long shopping_cart_id;//购物车主键
@property (nonatomic, copy) NSString *name;//商品名称
@property (nonatomic, copy) NSString *pic_url;//商品图片地址
@property (nonatomic, assign) int num;//商品数量
@property (nonatomic, copy) NSString *front_price;//商品显示价格
@property (nonatomic, copy) NSString *real_price;//商品真实价格
@property (nonatomic, copy) NSString *standard;//规格
@property (nonatomic, assign) int free_shipping_status;//免单状态 1:是 0否
@property (nonatomic, copy) NSString *free_shipping_amount;//免单金额


@end

@interface BN_ShoppingCartViewModel : NSObject

@property (nonatomic, strong, readonly) MultipleSectionTableArraySource *dataSource;
@property (assign, nonatomic, getter=isEdit) BOOL edit;

- (SectionDataSource *)getSectionDataSourceWith:(NSString *)title items:(NSArray <BN_ShoppingCartItemProtocol>*)items cellIdentifier:(NSString *)cellIdentifier configureCellBlock:(TableViewCellConfigureBlock)configureCellBlock configureSectionBlock:(TableViewSectionConfigureBlock)configureSectionBlock;

- (void)addDataSourceWith:(SectionDataSource *)sectionDataSource;

- (void)clearSelectedItems;
- (NSArray *)settlementSelectedItems;

- (NSAttributedString *)settlementCount;
- (NSString *)selectedItemPriceShow;
- (void)selectAll:(BOOL)isSelectedAll;
@end
