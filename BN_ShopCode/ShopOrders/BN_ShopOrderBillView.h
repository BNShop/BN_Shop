//
//  BN_ShopOrderBillView.h
//  BN_Shop
//
//  Created by Liya on 16/11/14.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+NIB.h"

@interface BN_ShopOrderBillView : UIView

- (void)addDeductionedPointForSelectedWithTask:(void (^)(BOOL deductioned))task;

- (void)updateWith:(NSString *)availablePoints retailPrice:(NSString *)retailPrice pointDeduction:(NSString *)pointDeduction freight:(NSString *)freight deductioned:(BOOL)deductioned;
- (CGFloat)getViewHeight;

@end
