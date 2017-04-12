//
//  UIView+NIB.m
//  BN_Shop
//
//  Created by Liya on 16/11/13.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "UIView+NIB.h"

@implementation UIView (NIB)
+ (instancetype)nib {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
}
@end
