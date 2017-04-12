//
//  BN_ShopCategoryModel.m
//  BN_Shop
//
//  Created by Liya on 2016/11/27.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopCategoryModel.h"

@implementation BN_ShopSecondCategoryModel

@end

@implementation BN_ShopCategoryModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.secondCategories = [[NSMutableArray alloc] initFromNet];
    }
    return self;
}

@end
