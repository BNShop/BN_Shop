//
//  NSString+Substitute.h
//  BN_Shop
//
//  Created by Liya on 16/11/15.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Substitute)
- (NSString *)safeStringByReplacingCharactersInRange:(NSRange)range withString:(NSString *)replacement;
@end
