//
//  BN_ShopGoodDetaiStateViewModel.m
//  BN_Shop
//
//  Created by Liya on 2016/11/20.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopGoodDetaiStateViewModel.h"
#import "NSString+Attributed.h"

@implementation BN_ShopGoodDetaiStateViewModel

- (NSAttributedString *)frontPriceAttrStr {
    return [[NSString stringWithFormat:@"¥%@", self.frontPrice] strikethroughAttribute];
}

- (NSString *)realPriceStr {
    return [NSString stringWithFormat:@"¥%@", self.realPrice];
}

- (NSString *)followNumStr {
    return [NSString stringWithFormat:@"%@%@", self.followNum, TEXT(@"关注")];
}

- (NSString *)saleNumStr {
    return [NSString stringWithFormat:@"%@%@%@", TEXT(@"已抢购"), self.saleNum, TEXT(@"件")];
}

- (NSString *)residueNumStr {
    return [NSString stringWithFormat:@"%@%@%@", TEXT(@"剩余"), self.residueNum, TEXT(@"件")];
}
@end
