//
//  BN_ShopOrderUserProfileViewModel.m
//  BN_Shop
//
//  Created by Liya on 16/11/14.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopOrderUserProfileViewModel.h"
#import "NSString+Substitute.h"

@implementation BN_ShopOrderUserProfileViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _tagged = YES;
    }
    return self;
}

- (NSString *)provinceAndCity {
    NSMutableString *address = [NSMutableString string];
    if ([_userProfile prov]) {
        [address appendString:[_userProfile prov]];
        [address appendString:@"  "];
    }
    if ([_userProfile city]) {
        [address appendString:[_userProfile city]];
        [address appendString:@"  "];
    }
    if ([_userProfile dist]) {
        [address appendString:[_userProfile dist]];
    }
    return [address copy];
}

- (NSString *)telNum {
    return [[_userProfile phone] safeStringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
}
@end
