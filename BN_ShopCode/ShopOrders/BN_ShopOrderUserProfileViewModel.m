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
    if ([_userProfile province]) {
        [address appendString:[_userProfile province]];
        [address appendString:@"  "];
    }
    if ([_userProfile city]) {
        [address appendString:[_userProfile city]];
        [address appendString:@"  "];
    }
    if ([_userProfile district]) {
        [address appendString:[_userProfile district]];
    }
    return [address copy];
}

- (NSString *)telNum {
    return [[_userProfile contactPersonPhoneNum] safeStringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
}
@end
