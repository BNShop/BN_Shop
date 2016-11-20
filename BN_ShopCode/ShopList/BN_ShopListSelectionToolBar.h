//
//  BN_ShopListSelectionToolBar.h
//  BN_Shop
//
//  Created by Liya on 16/11/15.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+NIB.h"

@protocol BN_ShopListSelectionToolBarProtocol;
@interface BN_ShopListSelectionToolBar : UIView

@property (weak, nonatomic) id<BN_ShopListSelectionToolBarProtocol> delegate;

- (CGFloat)getViewHeight;
- (void)updatePriceButtonWith:(BOOL)desc;
- (void)updateVLineWith:(BOOL)isV_Line;

@end

@protocol BN_ShopListSelectionToolBarProtocol <NSObject>
- (void)didRadioTag:(NSInteger)tag prevTag:(NSInteger)tag  groupId:(NSString *)groupId;
- (void)didFiltedTag:(NSInteger)tag;
@end

@interface BN_ShopListSelectionToolBar (RAC)
- (RACSignal *)rac_radioTagSignal;
- (RACSignal *)rac_filterSignal;
@end
