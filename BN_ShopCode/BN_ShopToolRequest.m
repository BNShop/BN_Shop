//
//  BN_ShopToolRequest.m
//  BN_Shop
//
//  Created by Liya on 2016/12/4.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopToolRequest.h"
#import "NSError+Description.h"

@implementation BN_ShopToolRequest
LY_SINGLETON_FOR_CLASS(BN_ShopToolRequest)

//收藏
- (void)collecteWith:(long)allSpotsId allSpotsType:(int)allSpotsType  success:(void(^)(int collecteState,  NSString *collecteMessage))success failure:(void(^)(NSString *errorDescription))failure {
    NSMutableDictionary *paraDic = nil;//http://xxx.xxx.xxx/homePage/scienicSpots/collecte（POST ）
    NSString *url = [NSString stringWithFormat:@"%@/homePage/scienicSpots/collecte?allSpotsId=%ld&allSpotsType=%d",BASEURL, allSpotsId, allSpotsType];
    [[BC_ToolRequest sharedManager] POST:url parameters:paraDic success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        if ([responseObject isKindOfClass:[NSData class]]) {
            dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        }
        NSNumber *codeNumber = [dic objectForKey:@"code"];
        if (codeNumber.intValue != 0) {
            NSString *errorStr = [dic objectForKey:@"remark"];
            if (failure) {
                failure(errorStr);
            }
        } else {
            int collecteState = [[dic objectForKey:@"collecteState"] intValue];
            NSString *collecteMessage = dic[@"collecteMessage"];
            if (success) {
                success(collecteState, collecteMessage);
            }
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        if (failure) {
            failure([error errorDescription]);
        }
    }];
}

//点赞
- (void)likeWith:(long)allSpotsId allSpotsType:(int)allSpotsType  success:(void(^)(int likedState, NSString *likedMessage))success failure:(void(^)(NSString *errorDescription))failure {
    NSMutableDictionary *paraDic = nil;//http://xxx.xxx.xxx/homePage/scienicSpots/collecte（POST ）
    NSString *url = [NSString stringWithFormat:@"%@/homePage/scienicSpots/like?allSpotsId=%ld&allSpotsType=%d",BASEURL, allSpotsId, allSpotsType];
    [[BC_ToolRequest sharedManager] POST:url parameters:paraDic success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        if ([responseObject isKindOfClass:[NSData class]]) {
            dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        }
        NSNumber *codeNumber = [dic objectForKey:@"code"];
        if (codeNumber.intValue != 0) {
            NSString *errorStr = [dic objectForKey:@"remark"];
            if (failure) {
                failure(errorStr);
            }
        } else {
            int likedState = [dic[@"likedState"] intValue];
            NSString *likedMessage = dic[@"likedMessage"];
            if (success) {
                success(likedState, likedMessage);
            }
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        if (failure) {
            failure([error errorDescription]);
        }
    }];
}

@end
