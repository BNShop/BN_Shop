//
//  BN_ShopGoodDetailSellersView.h
//  BN_Shop
//
//  Created by Liya on 2016/11/20.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BN_ShopGoodDetailSellersView : UIView
- (void)updateWith:(NSString *)sellerName iconUrl:(NSString *)iconUrl;
- (CGFloat)getViewHeight;
@end
