//
//  BN_ShopGoodDetaiForwardStateView.h
//  BN_Shop
//
//  Created by Liya on 2016/11/20.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+NIB.h"

@interface BN_ShopGoodDetaiForwardStateView : UIView

- (CGFloat)getViewHeight;
- (void)updateWith:(NSString *)realPrice frontPrice:(NSAttributedString *)frontPrice tips:(NSString *)tips follow:(NSString *)follow;
- (void)updateWith:(NSDate *)countDownDate countdownToLastSeconds:(NSInteger)countdownToLastSeconds;
@end
