//
//  BN_ShopGoodCommentsModel.m
//  BN_Shop
//
//  Created by Liya on 2016/11/29.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopGoodCommentsModel.h"
#import "NSArray+BlocksKit.h"

@implementation BN_ShopGoodCommentsModel
- (void)setPics:(NSArray *)pics {
    NSMutableArray *tmpUrls = [NSMutableArray array];
    [pics bk_each:^(id obj) {
        [tmpUrls addObject:obj[@"imageUrl"]];
    }];
    _pics = tmpUrls;
}
@end
