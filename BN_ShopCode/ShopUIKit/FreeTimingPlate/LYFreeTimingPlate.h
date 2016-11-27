//
//  LYFreeTimingPlate.h
//  日期倒计时
//
//  Created by Liya on 16/11/17.
//  Copyright © 2016年 carshoel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+NIB.h"

@protocol LYFreeTimingPlateDelegate;
@interface LYFreeTimingPlate : UIView

@property (nonatomic, strong) NSString *titleStr;//标题
@property (nonatomic, strong) NSDate *date;//倒计时预定时间
@property (nonatomic, assign) NSInteger countdownToLastSeconds;//剩多少时间时第一次提醒 s
@property (nonatomic, strong) dispatch_source_t timer;

@property (nonatomic, weak) id<LYFreeTimingPlateDelegate> delegate;

- (void)cancelTimer;

- (void)updatePlateWith:(UIColor *)color;
- (void)updateMinusWhioutBorderPlate;
@end


@protocol LYFreeTimingPlateDelegate <NSObject>

@optional
/**刚进入最后半小时会掉用这个方法*/
- (void)countdownToLastSecondsWillEnd:(LYFreeTimingPlate *)remainderView countdownToLastSeconds:(NSInteger)countdownToLastSeconds;
/**倒计时结束会掉用这个方法*/
- (void)countdownToLastDidEnd:(LYFreeTimingPlate *)remainderView;

@end
