//
//  BN_ShopHomeCategoryView.h
//  BN_Shop
//
//  Created by Liya on 16/11/17.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BN_ShopHomeCategoryViewDelegate;

@interface BN_ShopHomeCategoryView : UIView

@property (weak, nonatomic) id<BN_ShopHomeCategoryViewDelegate> delegate;

- (void)updateWith:(NSArray *)titles;
- (CGFloat)getViewHeight;

@end

@protocol BN_ShopHomeCategoryViewDelegate <NSObject>

- (void)shopHomeCategoryWith:(NSInteger)tag;

@end

@interface BN_ShopHomeCategoryView (RAC) <BN_ShopHomeCategoryViewDelegate>
- (RACSignal *)rac_shopHomeCategorySignal;
@end
