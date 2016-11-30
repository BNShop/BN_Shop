//
//  BN_ShopSouvenirModel.m
//  BN_Shop
//
//  Created by Liya on 2016/11/30.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopSouvenirModel.h"

@implementation BN_ShopSouvenirGoodModel


@end

@implementation BN_ShopSouvenirModel
- (void)setGoodsList:(NSMutableArray<BN_ShopSouvenirGoodModel *> *)goodsList {
    NSMutableArray *array = (NSMutableArray *)[goodsList map:^id(NSDictionary *element) {
        return [BN_ShopSouvenirGoodModel mj_objectWithKeyValues:element];
    }];
    _goodsList = array;
}
@end
