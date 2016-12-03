//
//  BN_ShopUserAddressModel.m
//  BN_Shop
//
//  Created by Liya on 2016/12/3.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopUserAddressModel.h"
#import "NSString+Substitute.h"

@implementation BN_ShopUserAddressModel


- (NSString *)provinceAndCity {
    NSMutableString *address = [NSMutableString string];
    if (_prov) {
        [address appendString:_prov];
        [address appendString:@"  "];
    }
    if (_city) {
        [address appendString:_city];
        [address appendString:@"  "];
    }
    if (_dist) {
        [address appendString:_dist];
    }
    return [address copy];
}

- (NSString *)telNum {
    return [_phone safeStringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
}
@end
