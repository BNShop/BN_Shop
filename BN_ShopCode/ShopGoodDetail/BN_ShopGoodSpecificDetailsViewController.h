//
//  BN_ShopGoodSpecificDetailsViewController.h
//  BN_Shop
//
//  Created by Liya on 2016/11/20.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "Base_BaseViewController.h"

@interface BN_ShopGoodSpecificDetailsViewController : Base_BaseViewController
@property (nonatomic, assign) CGFloat headerHight;
@property (nonatomic, assign) CGFloat footerHight;

- (instancetype)initWithHtml:(NSString *)html;
- (void)setHeadView:(UIView *)headView;
- (void)setFooterView:(UIView *)footerView;
- (CGPoint)contentOffset;
- (void)setContentOffset:(CGPoint)contentOffset;
@end
