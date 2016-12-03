//
//  BN_ShopOrderProcessingView.h
//  BN_Shop
// 订单处理情况
//  Created by Liya on 2016/12/1.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+NIB.h"

@interface BN_ShopOrderProcessingView : UIView
- (CGFloat)getViewHeight;
- (void)addLeftEventHandler:(void (^)(id sender))handler;
- (void)addRightEventHandler:(void (^)(id sender))handler;
- (void)updateWith:(NSString *)left rightTitle:(NSString *)right;
@end
