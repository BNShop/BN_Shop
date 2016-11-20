//
//  BN_ShopGoodDetailSimpleShowViewModel.m
//  BN_Shop
//
//  Created by Liya on 2016/11/19.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopGoodDetailSimpleShowViewModel.h"

@interface BN_ShopGoodDetailSimpleShowViewModel ()


@end

@implementation BN_ShopGoodDetailSimpleShowViewModel

- (NSArray *)thumbnailUrlList {
    return @[@"", @"", @""];
}

- (NSInteger)thumbnailCount {
    return 3;
    return [self.photoList count];
}

- (NSString *)scheduleWith:(NSInteger)index {
    if (self.thumbnailCount == 0) {
        return @"0/0";
    } else if (index == 0) {
        index = 1;
    }
    return [NSString stringWithFormat:@"%ld/%ld", (long)index, (long)[self thumbnailCount]];
}

@end
