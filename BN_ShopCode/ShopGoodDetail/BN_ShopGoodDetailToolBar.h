//
//  BN_ShopGoodDetailToolBar.h
//  BN_Shop
//
//  Created by Liya on 2016/11/19.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+NIB.h"

@protocol BN_ShopGoodDetailToolBarDelegate;
@interface BN_ShopGoodDetailToolBar : UIView

@property (nonatomic, weak) id<BN_ShopGoodDetailToolBarDelegate> delegte;
- (void)updateWithSelect:(BOOL)select;
- (void)updateWithAoppositeSelect;
- (CGFloat)getViewHeight;
@end

@protocol BN_ShopGoodDetailToolBarDelegate <NSObject>

- (void)goodDetailToolBarClickedWith:(UIButton *)sender;

@end

@interface BN_ShopGoodDetailToolBar (RAC) <BN_ShopGoodDetailToolBarDelegate>
- (RACSignal *)rac_shopGoodDetailToolBarClickSignal;
@end
