//
//  BN_ShopConditionTagModel.h
//  BN_Shop
//
//  Created by Liya on 2016/11/27.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, BN_ShopConditionClasses) {
    BN_ShopConditionClasses_Souvenir = 4,
    BN_ShopConditionClasses_SouvenirTopic = 14,
};

typedef NS_ENUM(NSUInteger, BN_ShopConditionTag) {
    BN_ShopConditionTag_Price = 3,
    BN_ShopConditionTag_Brand = 7,
    BN_ShopConditionTag_Suit = 8,
};

@interface BN_ShopConditionTagModel : NSObject
@property (nonatomic, assign) long tagId;//
@property (nonatomic, copy) NSString *tagName;//
@end

@interface BN_ShopConditionModel : NSObject

@property (nonatomic, assign) int classes;//4伴手礼 14伴手礼专题
@property (nonatomic, assign) int type;// 3价格 7品牌 8适合人群
@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *iconUrl;

@property (nonatomic, strong) NSMutableArray<BN_ShopConditionTagModel*> *tags;
@end
