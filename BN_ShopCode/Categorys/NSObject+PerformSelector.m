//
//  NSObject+PerformSelector.m
//  BN_Shop
//
//  Created by Liya on 2017/1/5.
//  Copyright © 2017年 GL_RunMan. All rights reserved.
//

#import "NSObject+PerformSelector.h"

@implementation NSObject (PerformSelector)
- (id)performSelector:(SEL)selector withObjects:(NSArray *)objects
{
    NSMethodSignature *signature = [self methodSignatureForSelector:selector];
    if (signature) {
        NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:self];
        [invocation setSelector:selector];
        for(int i = 0; i < [objects count]; i++){
            id object = [objects objectAtIndex:i];
            [invocation setArgument:&object atIndex: (i + 2)];
        }
        [invocation retainArguments];
        [invocation invoke];
        if (signature.methodReturnLength) {
            id anObject;
            [invocation getReturnValue:&anObject];
            return anObject;
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}
@end
