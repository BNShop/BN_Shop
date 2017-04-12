//
//  BN_ShopOrdersToolBar.h
//  BN_Shop
//
//  Created by Liya on 16/11/14.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+NIB.h"

@interface BN_ShopOrdersToolBar : UIView
- (void)placeAnOrderWith:(void (^)(id sender))handler;
- (void)updateWith:(NSString *)realPrice;

- (CGFloat)getViewHeight;

@end
