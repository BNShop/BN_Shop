//
//  NSString+URL.m
//  BN_Shop
//
//  Created by Liya on 16/11/13.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "NSString+URL.h"

@implementation NSString (URL)

- (NSURL *)URL {
    NSString *urlPath = [self Trim];
    if ([self length] == 0) {
        return nil;
    }
    if ([urlPath hasPrefix:@"/"]) {
        return [NSURL fileURLWithPath:urlPath];
    }
    return [NSURL URLWithString:[urlPath URLEncode]];
}

@end
