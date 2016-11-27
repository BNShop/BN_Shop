//
//  BN_ShopHomeSouvenirCellModel.m
//  BN_Shop
//
//  Created by Liya on 16/11/18.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopHomeSouvenirCellModel.h"

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

@implementation BN_ShopHomeSouvenirCellModel


- (NSString *)thumbnailUrl {
    return self.souvenirModel.pic_horizontal_url;
}

- (NSString *)title {
    return self.souvenirModel.name;
}


@end
