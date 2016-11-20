//
//  BN_ShopHomeADViewModel.m
//  BN_Shop
//
//  Created by Liya on 16/11/18.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopHomeADViewModel.h"

@interface BN_ShopHomeADViewModel ()

@end

@implementation BN_ShopHomeADViewModel

- (NSArray *)adUrlList {
    return @[@"", @"", @""];
}

- (NSInteger)adCount {
    return 3;
}

- (id)adItemWithIndex:(NSInteger)index {
    if (index >= 0 && index < [self.adList count]) {
        NSArray *tmps = self.adList.copy;
        return [tmps objectAtIndex:index];
    }
    return nil;
}

@end
