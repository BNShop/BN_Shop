//
//  PurchaseConsultingViewController.h
//  BN_Shop
//
//  Created by Liya on 16/11/13.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "Base_BaseViewController.h"
@protocol PurchaseConsultingViewControllerDelegate;
@interface PurchaseConsultingViewController : Base_BaseViewController
@property (nonatomic, weak) id<PurchaseConsultingViewControllerDelegate> delegate;
@end

@protocol PurchaseConsultingViewControllerDelegate <NSObject>
- (void)purchaseConsultingViewControllerWith:(NSString *)text;
@end
