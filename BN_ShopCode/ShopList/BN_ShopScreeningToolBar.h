//
//  BN_ShopScreeningToolBar.h
//  BN_Shop
//
//  Created by Liya on 16/11/16.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+NIB.h"

@interface BN_ShopScreeningToolBar : UIView

- (void)addOkEventHandler:(void (^)(id sender))handler;
- (void)addCancleEventHandler:(void (^)(id sender))handler;

- (CGFloat)getViewHeight;

@end
