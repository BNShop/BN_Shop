//
//  BN_ShopToolRequest.m
//  BN_Shop
//
//  Created by Liya on 2016/12/4.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopToolRequest.h"
#import "NSError+Description.h"
#import "BN_ShopHeader.h"

@implementation BN_ShopToolRequest
LY_SINGLETON_FOR_CLASS(BN_ShopToolRequest)

//收藏
- (void)collecteWith:(long)allSpotsId allSpotsType:(int)allSpotsType  success:(void(^)(int collecteState,  NSString *collecteMessage))success failure:(void(^)(NSString *errorDescription))failure {
    NSDictionary *paraDic = @{@"allSpotsId":@(allSpotsId), @"allSpotsType":@(allSpotsType)};
    NSString *url = [NSString stringWithFormat:@"%@/homePage/scienicSpots/collecte", Shop_BASEURL];
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
            dic = dic[@"result"];
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
    NSString *url = [NSString stringWithFormat:@"%@/homePage/scienicSpots/like?allSpotsId=%ld&allSpotsType=%d", Shop_BASEURL, allSpotsId, allSpotsType];
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

//微信支付
- (void)webchatPrePayWith:(NSArray *)orderIDs success:(void(^)(PayReq *payReq))success failure:(void(^)(NSString *errorDescription))failure {
    if (orderIDs.count == 0) {
        if (failure) {
            failure(TEXT(@"选择支付选项"));
        }
        return;
    }
    NSMutableDictionary *paraDic = nil;
    NSString *url = [NSString stringWithFormat:@"%@/wxpay/webchatPrePay?orderId=%@", Shop_BASEURL, [orderIDs componentsJoinedByString:@","]];
    [[BC_ToolRequest sharedManager] GET:url parameters:paraDic success:^(NSURLSessionDataTask *operation, id responseObject) {
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
            dic = dic[@"result"];
            PayReq *payReq = [PayReq new];
            payReq = [[PayReq alloc] init];
            payReq.partnerId = dic[@"partnerid"];
            payReq.prepayId = dic[@"prepayid"];
            payReq.package = dic[@"packageType"];
            payReq.nonceStr = dic[@"noncestr"];
            payReq.timeStamp = [dic[@"timestamp"] intValue];
            payReq.sign = dic[@"sign"];
            if (success) {
                success(payReq);
            }
            NSLog(@"payReq = %@", dic);
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        if (failure) {
            failure([error errorDescription]);
        }
    }];

}

//支付宝支付
- (void)alipayPrePayWith:(NSArray *)orderIDs success:(void(^)(NSString *orderInfo))success failure:(void(^)(NSString *errorDescription))failure {
    if (orderIDs.count == 0) {
        if (failure) {
            failure(TEXT(@"选择支付选项"));
        }
        return;
    }
    NSMutableDictionary *paraDic = nil;
    NSString *url = [NSString stringWithFormat:@"%@/alipay/getOrderInfo?orderId=%@", Shop_BASEURL, [orderIDs componentsJoinedByString:@","]];
    [[BC_ToolRequest sharedManager] GET:url parameters:paraDic success:^(NSURLSessionDataTask *operation, id responseObject) {
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
            if (success) {
                success((dic[@"result"])[@"orderInfo"]);
            }
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        if (failure) {
            failure([error errorDescription]);
        }
    }];
    
}

//设置提醒已否
- (void)warnORCancelRes:(BOOL)isWarn goodsId:(long)goodsId success:(void(^)(long warn_id))success failure:(void(^)(NSString *errorDescription))failure {
    NSDictionary *paraDic = nil;
    
    NSString *url = [NSString stringWithFormat:@"%@/mall/warn?goodsId=%ld", Shop_BASEURL, goodsId];
    if (!isWarn) {
        url = [NSString stringWithFormat:@"%@/mall/cancelWarn?warnId=%ld", Shop_BASEURL, goodsId];
    }
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
            NSLog(@"dic = %@", dic);
            dic = dic[@"result"];
            if (success) {
                if (isWarn) {
                    long warn_id = [dic[@"warnId"] longValue];
                    success(warn_id);
                } else {
                    success(-1);
                }
            }
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        if (failure) {
            failure([error errorDescription]);
        }
    }];
    
}

//购物车数量
- (void)getShoppingCartNumRes:(void(^)(long num))success failure:(void(^)(NSString *errorDescription))failure {
    NSString *url = [NSString stringWithFormat:@"%@/mall/shoppingCartNum", Shop_BASEURL];
    [[BC_ToolRequest sharedManager] GET:url parameters:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
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
            NSLog(@"dic = %@", dic);
            if (success) {
                success([dic[@"result"] longValue]);
            }
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        if (failure) {
            failure([error errorDescription]);
        }
    }];

}


@end
