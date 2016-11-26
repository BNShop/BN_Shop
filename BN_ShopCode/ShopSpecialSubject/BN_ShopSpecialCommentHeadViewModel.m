//
//  BN_ShopSpecialCommentHeadViewModel.m
//  BN_Shop
//
//  Created by Liya on 2016/11/22.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopSpecialCommentHeadViewModel.h"

@implementation BN_ShopSpecialCommentHeadViewModel

- (NSString *)numStr {
    return [NSString stringWithFormat:@"%@%@", self.num, TEXT(@"位达人已收藏")];
}

@end
