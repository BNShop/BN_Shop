//
//  BN_ShopGoodDetailTransitionToolBar.h
//  BN_Shop
//
//  Created by Liya on 2016/11/24.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BN_ShopGoodDetailTransitionToolBar : UIView
- (void)updateWith:(NSString *)commentNum segmentedControlChangedValue:(void(^)(NSInteger selectedIndex))block;
- (void)updateWith:(NSString *)commentNum;
- (CGFloat)getViewHeight;
@end
