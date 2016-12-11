//
//  NSString+URL.m
//  BN_Shop
//
//  Created by Liya on 16/11/13.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "NSString+URL.h"
#import "BN_ShopHeader.h"

@implementation NSString (URL)

- (NSURL *)URL {
    
    NSString *urlPath = [self Trim];
    NSLog(@"url = %@", urlPath);
    if ([self length] == 0) {
        return nil;
    }
    if ([urlPath hasPrefix:@"/"]) {
        return [NSURL fileURLWithPath:urlPath];
    }
    return [NSURL URLWithString:urlPath];
}

@end
