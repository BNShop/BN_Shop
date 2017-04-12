//
//  BN_ShoppingCartHeardView.h
//  BN_Shop
//
//  Created by Liya on 16/11/13.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+NIB.h"
@interface BN_ShoppingCartHeardView : UIView

- (CGFloat)getViewHeight;
- (void)updateWith:(NSString *)warningTitle roundUpTitle:(NSString *)roundUpTitle roundUpBlock:(void(^)(id obj)) block;
@end
