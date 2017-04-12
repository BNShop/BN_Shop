//
//  NSString+Substitute.m
//  BN_Shop
//
//  Created by Liya on 16/11/15.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "NSString+Substitute.h"

@implementation NSString (Substitute)
- (NSString *)safeStringByReplacingCharactersInRange:(NSRange)range withString:(NSString *)replacement {
    
    NSRange sourceRange = [self rangeOfString:self];
    if (range.location >= sourceRange.length) {
        return [self copy];
    }
    if (range.location + range.length > sourceRange.length) {
        range.length = sourceRange.length - range.location;
    }
    
    
    return [self stringByReplacingCharactersInRange:range withString:replacement];
}
@end
