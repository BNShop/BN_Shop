//
//  BN_ShopSpecialCommentFootView.h
//  BN_Shop
//
//  Created by Liya on 2016/11/22.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+NIB.h"

@interface BN_ShopSpecialCommentFootView : UIView
- (void)clickedCommentAction:(void (^)(id sender))handler;
- (CGFloat)getViewHeight;
@end
