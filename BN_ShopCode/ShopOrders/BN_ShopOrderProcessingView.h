//
//  BN_ShopOrderProcessingView.h
//  BN_Shop
//
//  Created by Liya on 2016/12/1.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BN_ShopOrderProcessingView : UIView
- (CGFloat)getViewHeight;
- (void)addLeftEventHandler:(void (^)(id sender))handler;
- (void)addRightEventHandler:(void (^)(id sender))handler;
- (void)updateWith:(NSString *)left rightTitle:(NSString *)right;
@end
