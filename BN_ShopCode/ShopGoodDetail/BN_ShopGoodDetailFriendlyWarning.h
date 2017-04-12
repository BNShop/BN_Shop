//
//  BN_ShopGoodDetailFriendlyWarning.h
//  BN_Shop
//
//  Created by Liya on 2016/11/20.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BN_ShopGoodDetailFriendlyWarning : UIView
- (void)updateWith:(NSString *)postage point:(NSString *)point deliver:(NSString *)deliver;

- (CGFloat)getViewHeight;
@end
