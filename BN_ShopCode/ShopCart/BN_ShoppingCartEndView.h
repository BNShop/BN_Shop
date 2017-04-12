//
//  BN_ShoppingCartEndView.h
//  BN_Shop
//
//  Created by Liya on 16/11/13.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+NIB.h"
@protocol BN_ShoppingCartEndViewDelegate;

@interface BN_ShoppingCartEndView : UIView
@property (nonatomic, assign, getter=isEdit) BOOL edit;
@property (nonatomic, weak) id<BN_ShoppingCartEndViewDelegate> delegate;

- (CGFloat)getViewHeight;
- (void)updateWith:(BOOL)isCheckAll;
- (void)updateWith:(NSString *)totalAmount settlementTitle:(NSAttributedString *)settlementTitle;
@end


@protocol BN_ShoppingCartEndViewDelegate <NSObject>
- (void)selectAll:(BOOL)isSelect;
- (void)deleteTagger;
- (void)settlementTagger;
@end
