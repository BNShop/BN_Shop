//
//  BN_ShoppingCartItemProtocol.h
//  BN_Shop
//
//  Created by Liya on 16/11/14.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BN_ShoppingCartItemProtocol <NSObject>

@property (assign, nonatomic, getter=isSelected) BOOL selected;
@property (assign, nonatomic) NSInteger num;
@property (nonatomic, copy) NSString *front_price;
@property (nonatomic, copy) NSString *real_price;

@end
