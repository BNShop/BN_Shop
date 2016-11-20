//
//  BN_ShopSearchCollectionReusableView.h
//  BN_Shop
//
//  Created by Liya on 16/11/17.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BN_ShopSearchCollectionReusableView : UICollectionReusableView

- (void)addOkEventHandler:(void (^)(id sender))handler;

- (void)updateWith:(NSString *)iconUrl title:(NSString *)title;
- (CGFloat)getViewHeight;

@end
