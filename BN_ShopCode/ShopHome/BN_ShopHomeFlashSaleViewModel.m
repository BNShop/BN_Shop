//
//  BN_ShopHomeFlashSaleViewModel.m
//  BN_Shop
//
//  Created by Liya on 16/11/17.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopHomeFlashSaleViewModel.h"
#import "NSString+Attributed.h"

@interface BN_ShopHomeFlashSaleViewModel ()



@end

@implementation BN_ShopHomeFlashSaleViewModel

- (NSAttributedString *)priceAttri {
    return [[NSString stringWithFormat:@"¥ %@", self.price] setFont:Font12 restFont:Font15 range:NSMakeRange(0, 1)];
}

@end
