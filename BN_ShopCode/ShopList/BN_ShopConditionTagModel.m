//
//  BN_ShopConditionTagModel.m
//  BN_Shop
//
//  Created by Liya on 2016/11/27.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopConditionTagModel.h"

@implementation BN_ShopConditionTagModel

@end

@implementation BN_ShopConditionModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.tags = [[NSMutableArray alloc] initFromNet];
    }
    return self;
}

@end
