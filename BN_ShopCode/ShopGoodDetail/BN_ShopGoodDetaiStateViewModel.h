//
//  BN_ShopGoodDetaiStateViewModel.h
//  BN_Shop
//
//  Created by Liya on 2016/11/20.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, GoodDetaiStateType) {
    GoodDetaiState_Normal,
    GoodDetaiState_Forward,
     GoodDetaiState_Panic,
};

@interface BN_ShopGoodDetaiStateViewModel : NSObject

@property (nonatomic, assign) GoodDetaiStateType state;//0 1 2

@property (nonatomic, copy) NSString *realPrice;
@property (nonatomic, copy) NSString *frontPrice;
@property (nonatomic, copy) NSString *followNum;

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, copy) NSString *saleNum;
@property (nonatomic, copy) NSString *residueNum;
@property (nonatomic, copy) NSString *tips;

- (NSAttributedString *)frontPriceAttrStr;
- (NSString *)realPriceStr;
- (NSString *)followNumStr;
- (NSString *)saleNumStr;
- (NSString *)residueNumStr;
@end
