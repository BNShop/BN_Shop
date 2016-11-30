//
//  BN_ShopGoodDetailConsultancyViewModel.h
//  BN_Shop
//
//  Created by Liya on 2016/11/24.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableDataSource.h"
#import "BN_ShopGoodDetailConsultancyModel.h"

@interface BN_ShopGoodDetailConsultancyViewModel : NSObject
@property (nonatomic, strong) TableDataSource *dataSource;
@property (nonatomic, strong) NSMutableArray<BN_ShopGoodDetailConsultancyModel*> *items;
@property (nonatomic, assign) long goodsId;//商品ID

- (void)sendConsultingWith:(NSString *)text failure:(void(^)(NSString *errorStr))failure;
- (void)getAnswersListClearData:(BOOL)clear;
@end
