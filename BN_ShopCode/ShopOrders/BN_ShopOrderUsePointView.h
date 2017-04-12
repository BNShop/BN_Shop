//
//  BN_ShopOrderUsePointView.h
//  BN_Shop
//
//  Created by Liya on 2016/12/1.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+NIB.h"

@interface BN_ShopOrderUsePointView : UIView
- (void)addDeductionedPointForSelectedWithTask:(void (^)(BOOL deductioned))task;
- (void)updateWith:(NSString *)availablePoints deductioned:(BOOL)deductioned;
- (CGFloat)getViewHeight;
@end
