//
//  BN_ShopOrdersConfirmationViewController.h
//  BN_Shop
//
//  Created by Liya on 16/11/14.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "Base_BaseViewController.h"

@interface BN_ShopOrdersConfirmationViewController : Base_BaseViewController
- (instancetype)initWith:(NSArray *)shoppingCartIds numbers:(NSArray *)numbers;
- (instancetype)initWithSpecial:(long)goodid num:(int)num;
@end
