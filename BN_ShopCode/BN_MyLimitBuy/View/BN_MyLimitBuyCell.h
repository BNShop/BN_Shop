//
//  BN_MyLimitBuyCell.h
//  BN_Shop
//
//  Created by yuze_huang on 2017/1/1.
//  Copyright © 2017年 GL_RunMan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BN_MycollectionModel.h"
#import "UITableViewCell+NIB.h"
@protocol BN_MyLimitBuyCellDelegate;

@interface BN_MyLimitBuyCell : UITableViewCell

@property (nonatomic, weak) id<BN_MyLimitBuyCellDelegate> delegate;

- (void)updateViewWithModel:(BN_MycollectionModel *)model;

- (void)buildTimePlate;
- (void)addManageButtonEvent:(void (^)(id sender))handler;
- (void)updateAdditionalFrenzied:(NSDate *)date;
- (void)updateAdditionalForward:(NSDate *)date state:(int)state;
- (void)updateAdditionalFinish;
- (void)cancelTimer;

@end

@protocol BN_MyLimitBuyCellDelegate <NSObject>
- (void)selectActionWith:(UITableViewCell *)cell selected:(BOOL)selected ;
- (void)valueChangedWith:(UITableViewCell *)cell count:(float)count;
@end
