//
//  BN_ShopGoodHorizontalCell.h
//  BN_Shop
//
//  Created by Liya on 16/11/15.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableViewCell+NIB.h"

@interface BN_ShopGoodHorizontalCell : UICollectionViewCell

- (void)updateWith:(NSString *)thumbnailUrl title:(NSString *)title front:(NSAttributedString *)front real:(NSString *)real additional:(NSString *)additional;

- (void)buildTimePlate;
- (void)addManageButtonEvent:(void (^)(id sender))handler;
- (void)updateAdditionalFrenzied:(NSDate *)date;
- (void)updateAdditionalForward:(NSDate *)date state:(int)state;
- (void)updateAdditionalFinish;
- (void)cancelTimer;
@end
