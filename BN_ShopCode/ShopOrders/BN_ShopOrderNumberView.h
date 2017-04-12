//
//  BN_ShopOrderNumberView.h
//  BN_Shop
//
//  Created by Liya on 2016/12/1.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+NIB.h"

@interface BN_ShopOrderNumberView : UIView
- (void)updateWith:(NSString *)title content:(NSString *)content;
- (void)updateOrderStateContent;
- (void)updateOrderPriceContent;
- (void)udatewithContentAttr:(NSAttributedString *)content;
- (CGFloat)getViewHeight;
@end
