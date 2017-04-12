//
//  BN_ShopGoodDetailNewestOrdersView.h
//  BN_Shop
//
//  Created by Liya on 2017/1/7.
//  Copyright © 2017年 GL_RunMan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+NIB.h"

@interface BN_ShopGoodDetailNewestOrdersView : UIView

@property (nonatomic, strong) NSLayoutConstraint *widthConstraint;

- (void)updateWith:(NSString *)iconUrl title:(NSString *)title;
- (CGFloat)getViewWidth;
@end
