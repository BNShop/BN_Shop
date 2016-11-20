//
//  BN_ShopScreeningReusableView.h
//  BN_Shop
//
//  Created by Liya on 16/11/16.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+NIB.h"

@interface BN_ShopScreeningReusableView : UICollectionReusableView
- (void)updateWith:(NSString *)iconUrl title:(NSString *)title;
- (CGFloat)getViewHeight;
@end
