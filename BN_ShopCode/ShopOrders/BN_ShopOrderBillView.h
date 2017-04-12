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
- (CGFloat)getViewHeight;
- (void)updateWith:(NSString *)retailPrice pointDeduction:(NSString *)pointDeduction freight:(NSString *)freight;
@end
