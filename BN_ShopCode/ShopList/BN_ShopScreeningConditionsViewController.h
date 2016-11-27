//
//  TestViewController.h
//  BN_Shop
//
//  Created by Liya on 16/11/16.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "Base_BaseViewController.h"

@protocol BN_ShopScreeningConditionsViewControllerProtocol;

@interface BN_ShopScreeningConditionsViewController : Base_BaseViewController

@property (weak, nonatomic) id<BN_ShopScreeningConditionsViewControllerProtocol> delegate;

- (instancetype)initWithBankTagId:(long)bankTagId priceTagId:(long)priceTagId suitTagId:(long)suitTagId;
@end

@protocol BN_ShopScreeningConditionsViewControllerProtocol <NSObject>
- (void)screeningConditionsWith:(long)priceTagId suitTagId:(long)suitTagId bankTagId:(long)bankTagId;
- (void)dismissConditions;
@end

@interface BN_ShopScreeningConditionsViewController (RAC)
- (RACSignal *)rac_screeningConditionsSignal;
- (RACSignal *)rac_dismissConditionsSignal;
@end

