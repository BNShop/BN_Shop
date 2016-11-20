//
//  BN_ShopGoodDetaiNormalStateView.h
//  BN_Shop
//
//  Created by Liya on 2016/11/20.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+NIB.h"

@interface BN_ShopGoodDetaiNormalStateView : UIView
- (void)updateWith:(NSString *)realPrice frontPrice:(NSAttributedString *)frontPrice;
- (CGFloat)getViewHeight;
@end
