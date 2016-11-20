//
//  BN_ShopHomeFlashSaleViewModel.h
//  BN_Shop
//
//  Created by Liya on 16/11/17.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BN_ShopHomeFlashSaleViewModel : NSObject

@property (nonatomic, copy) NSString *thumbnailUrl;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *instruction;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, copy) NSString *timeTitle;
@property (nonatomic, assign) NSInteger countdownToLastSeconds;
@property (nonatomic, assign) BOOL plus;

- (NSAttributedString *)priceAttri;

@end
