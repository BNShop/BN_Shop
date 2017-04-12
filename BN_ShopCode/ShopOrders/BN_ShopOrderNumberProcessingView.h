//
//  BN_ShopOrderNumberProcessingView.h
//  BN_Shop
//
//  Created by Liya on 2016/12/4.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+NIB.h"

@interface BN_ShopOrderNumberProcessingView : UIView
- (void)updateWith:(NSString *)title content:(NSString *)content;
- (void)updateOrderStateContent;
- (void)updateOrderPriceContent;
- (void)udatewithContentAttr:(NSAttributedString *)content;
- (void)updateWith:(UIColor *)bgColor q_color:(UIColor *)q_color titleColor:(UIColor *)titleColor title:(NSString *)title;
- (void)addEventHandler:(void (^)(id sender))handler;
- (CGFloat)getViewHeight;
@end
