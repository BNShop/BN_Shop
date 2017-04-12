//
//  BN_ShopGoodDetaiPanicStateView.h
//  BN_Shop
//
//  Created by Liya on 2016/11/20.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+NIB.h"

@interface BN_ShopGoodDetaiPanicStateView : UIView
- (void)updateWith:(NSString *)realPrice frontPrice:(NSAttributedString *)frontPrice saleNum:(NSString *)saleNum residue:(NSString *)residue;
- (void)updateWith:(NSDate *)countDownDate countdownToLastSeconds:(NSInteger)countdownToLastSeconds;
- (CGFloat)getViewHeight;
@end
