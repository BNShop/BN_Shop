//
//  NSError+Description.m
//  BN_Shop
//
//  Created by Liya on 2016/11/27.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "NSError+Description.h"

@implementation NSError (Description)
- (NSString *)errorDescription {
    return [[self userInfo] objectForKey:NSLocalizedDescriptionKey];
}
@end
