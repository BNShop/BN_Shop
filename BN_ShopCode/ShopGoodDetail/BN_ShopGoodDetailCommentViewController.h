//
//  BN_ShopGoodDetailCommentViewController.h
//  BN_Shop
//
//  Created by Liya on 2016/11/20.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "Base_BaseViewController.h"

@interface BN_ShopGoodDetailCommentViewController : Base_BaseViewController
- (instancetype)initWith:(long)goodId type:(int)type;
- (void)setCommentAvgScore:(int)avg_score;//平均分

- (void)setHeadView:(UIView *)view;
- (CGPoint)contentOffset;
- (void)setContentOffset:(CGPoint)contentOffset;
@end
