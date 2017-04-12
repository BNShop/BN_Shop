//
//  BN_ShopToolRequest.h
//  BN_Shop
//
//  Created by Liya on 2016/12/4.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYSingleton.h"
#import "WXApi.h"

@interface BN_ShopToolRequest : NSObject
LY_SINGLETON_FOR_CLASS_HEADER(BN_ShopToolRequest)

//收藏
- (void)collecteWith:(long)allSpotsId allSpotsType:(int)allSpotsType  success:(void(^)(int collecteState, NSString *collecteMessage))success failure:(void(^)(NSString *errorDescription))failure;

//点赞
- (void)likeWith:(long)allSpotsId allSpotsType:(int)allSpotsType  success:(void(^)(int likedState, NSString *likedMessage))success failure:(void(^)(NSString *errorDescription))failure;

//微信支付
- (void)webchatPrePayWith:(NSArray *)orderIDs success:(void(^)(PayReq *payReq))success failure:(void(^)(NSString *errorDescription))failure;

//支付宝支付
- (void)alipayPrePayWith:(NSArray *)orderIDs success:(void(^)(NSString *orderInfo))success failure:(void(^)(NSString *errorDescription))failure;

//平安支付s
- (void)pinganPrePayWith:(NSArray *)orderIDs success:(void(^)(NSString *payUrlForApp))success failure:(void(^)(NSString *errorDescription))failure;

//设置提醒已否
- (void)warnORCancelRes:(BOOL)isWarn goodsId:(long)goodsId success:(void(^)(long warn_id))success failure:(void(^)(NSString *errorDescription))failure;

//购物车数量
- (void)getShoppingCartNumRes:(void(^)(long num))success failure:(void(^)(NSString *errorDescription))failure;
@end
