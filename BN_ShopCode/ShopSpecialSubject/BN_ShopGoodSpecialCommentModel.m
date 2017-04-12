//
//  BN_ShopGoodSpecialCommentModel.m
//  BN_Shop
//
//  Created by Liya on 2016/11/30.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopGoodSpecialCommentModel.h"

@implementation BN_ShopGoodSpecialCommentModel
- (void)setPics:(NSArray *)pics {
    NSMutableArray *array = (NSMutableArray *)[pics map:^id(NSDictionary *element) {
        return element[@"imageUrl"];
    }];
    _pics = array;
}

@end
