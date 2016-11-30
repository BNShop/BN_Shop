//
//  BN_ShopGoodModel.m
//  BN_Shop
//
//  Created by Liya on 2016/11/27.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopGoodModel.h"

@implementation BN_ShopGoodModel

- (NSDate *)date {
    if (self.timeleft <= 0) {
        return nil;
    }
    return [NSDate dateWithTimeIntervalSinceNow:self.timeleft];;
}

@end
