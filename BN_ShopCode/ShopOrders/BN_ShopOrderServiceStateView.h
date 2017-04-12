//
//  BN_ShopOrderServiceStateView.h
//  BN_Shop
// 客服状态
//  Created by Liya on 2016/12/1.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+NIB.h"

@interface BN_ShopOrderServiceStateView : UIView
- (void)updateServerHelp;
- (void)updateServerStateFinish;//0处理中，1已完成
- (void)updateServerStateIng;//0处理中，1已完成
- (CGFloat)getViewHeight;
@end
