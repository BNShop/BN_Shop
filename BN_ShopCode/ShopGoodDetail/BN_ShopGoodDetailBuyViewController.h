//
//  BN_ShopGoodDetailBuyViewController.h
//  BN_Shop
//
//  Created by Liya on 2016/11/29.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "Base_BaseViewController.h"
@protocol BN_ShopGoodDetailBuyViewControllerDelegate;
@interface BN_ShopGoodDetailBuyViewController : Base_BaseViewController

@property (nonatomic, weak) id<BN_ShopGoodDetailBuyViewControllerDelegate> delegate;

- (instancetype)initWith:(NSString *)iconUrl standards:(NSString *)standards price:(NSString *)price;
@end

@protocol BN_ShopGoodDetailBuyViewControllerDelegate <NSObject>

- (void)goodDetailBuyCountWith:(int)cout;

@end
