//
//  BN_ShopGoodDetailConsultancyViewController.h
//  BN_Shop
//
//  Created by Liya on 2016/11/20.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "Base_BaseViewController.h"

@interface BN_ShopGoodDetailConsultancyViewController : Base_BaseViewController

- (instancetype)initWith:(long)goodsId;

- (void)setHeadView:(UIView *)view;
- (CGPoint)contentOffset;
- (void)setContentOffset:(CGPoint)contentOffset;
@end
