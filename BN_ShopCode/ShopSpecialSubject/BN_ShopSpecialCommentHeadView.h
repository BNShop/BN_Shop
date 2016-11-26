//
//  BN_ShopSpecialCommentHeadView.h
//  BN_Shop
//
//  Created by Liya on 2016/11/22.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+NIB.h"

@interface BN_ShopSpecialCommentHeadView : UIView
- (void)clickedFollowAction:(void (^)(id sender))handler;
- (void)updateWith:(NSString *)titile follow:(BOOL)follow;
- (void)updateWith:(NSArray *)imgUrls;
- (CGFloat)getViewHeight;
@end
