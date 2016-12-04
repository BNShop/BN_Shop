//
//  BN_ShopToolRequest.h
//  BN_Shop
//
//  Created by Liya on 2016/12/4.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYSingleton.h"

@interface BN_ShopToolRequest : NSObject
LY_SINGLETON_FOR_CLASS_HEADER(BN_ShopToolRequest)

//收藏
- (void)collecteWith:(long)allSpotsId allSpotsType:(int)allSpotsType  success:(void(^)(int collecteState, NSString *collecteMessage))success failure:(void(^)(NSString *errorDescription))failure;
//点赞
- (void)likeWith:(long)allSpotsId allSpotsType:(int)allSpotsType  success:(void(^)(int likedState, NSString *likedMessage))success failure:(void(^)(NSString *errorDescription))failure;


@end
