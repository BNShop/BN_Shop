//
//  BN_ShopOrderUserProfileView.h
//  BN_Shop
//
//  Created by Liya on 16/11/14.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+NIB.h"

@interface BN_ShopOrderUserProfileView : UIView

- (void)updateWith:(NSString *)name tel:(NSString *)tel tagged:(BOOL)tagged provinces:(NSString *)provinces street:(NSString *)street;
- (CGFloat)getViewHeight;

@end
