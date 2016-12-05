//
//  BN_ShopPaymentViewController.h
//  BN_Shop
//
//  Created by Liya on 2016/12/5.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "Base_BaseViewController.h"
#import "BN_ShopPaymentViewModel.h"
@protocol BN_ShopPaymentViewControllerDelegate;
@interface BN_ShopPaymentViewController : Base_BaseViewController

@property (weak, nonatomic) id<BN_ShopPaymentViewControllerDelegate> delegate;

- (instancetype)init:(BN_ShopPaymentViewModel *)viewModel;

@end


@protocol BN_ShopPaymentViewControllerDelegate <NSObject>

- (void)paymentViewControllerWithSucess:(NSArray *)orderIds type:(BN_ShopPaymentType)type payAccount:(NSString *)payAccount;

@end
