//
//  BN_ShopHomeFlashSaleView.h
//  BN_Shop
//
//  Created by Liya on 16/11/17.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BN_ShopHomeFlashSaleViewDelegate;
@interface BN_ShopHomeFlashSaleView : UIView

@property (nonatomic, weak) id<BN_ShopHomeFlashSaleViewDelegate> delegate;

- (void)updateWith:(NSString *)thumbnailUrl title:(NSString *)title instruction:(NSString *)instruction price:(NSAttributedString *)price;
- (void)updateWith:(NSDate *)countDownDate title:(NSString *)title countdownToLastSeconds:(NSInteger)countdownToLastSeconds timeColor:(UIColor *)timeColor;
- (CGFloat)getViewHeight;
@end

@protocol BN_ShopHomeFlashSaleViewDelegate <NSObject>
- (void)countdownToLastSecondsWillEnd:(NSInteger)countdownToLastSeconds;
- (void)countdownToLastDidEnd;
@end

@interface BN_ShopHomeFlashSaleView (RAC) <BN_ShopHomeFlashSaleViewDelegate>
- (RACSignal *)rac_countdownToLastSecondsWillEndSignal;
- (RACSignal *)rac_ccountdownToLastDidEndSignal;
@end
