//
//  BN_ShopOrderServiceStateView.h
//  BN_Shop
//
//  Created by Liya on 2016/12/1.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BN_ShopOrderServiceStateView : UIView
- (void)updateServerHelp;
- (void)updateServerState:(int)state;//0处理中，1已完成
- (CGFloat)getViewHeight;
@end
