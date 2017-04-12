//
//  NSObject+PerformSelector.h
//  BN_Shop
//
//  Created by Liya on 2017/1/5.
//  Copyright © 2017年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (PerformSelector)
- (id)performSelector:(SEL)selector withObjects:(NSArray *)objects;
@end
