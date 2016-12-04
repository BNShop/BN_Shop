//
//  BN_ShopGoodDetaiStateViewModel.m
//  BN_Shop
//
//  Created by Liya on 2016/11/20.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopGoodDetaiStateViewModel.h"
#import "NSString+Attributed.h"
#import "NSError+Description.h"

@implementation BN_ShopGoodSimpleDetailModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"goodDescription":@"description"};
}
@end

@implementation BN_ShopGoodDetaiStateViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.simpleDetailModel = [[BN_ShopGoodSimpleDetailModel alloc] init];
    }
    return self;
}

- (NSAttributedString *)frontPriceAttrStr {
    return [[NSString stringWithFormat:@"¥%@", self.simpleDetailModel.front_price] strikethroughAttribute];
}

- (NSString *)realPriceStr {
    return [NSString stringWithFormat:@"¥%@", self.simpleDetailModel.real_price];
}

- (NSString *)followNumStr {
    return [NSString stringWithFormat:@"%d%@", self.simpleDetailModel.total_like, TEXT(@"关注")];
}

- (NSString *)commentNumStr {
    return [NSString stringWithFormat:@"%d", self.simpleDetailModel.total_comment];
}

- (NSString *)saleNumStr {
    return [NSString stringWithFormat:@"%@%d%@", TEXT(@"已抢购"), self.simpleDetailModel.out_buying_num, TEXT(@"件")];
}

- (NSString *)residueNumStr {
    return [NSString stringWithFormat:@"%@%d%@", TEXT(@"剩余"), self.simpleDetailModel.avail_buying_num, TEXT(@"件")];
}

- (GoodDetaiStateType)state {
//    if (self.simpleDetailModel.buying_end_time.length == 0 && self.simpleDetailModel.buying_start_time.length == 0) {
//        return GoodDetaiState_Normal;
//    }
    return self.simpleDetailModel.buying_state;
}

- (NSDate *)date {
    if (self.state == GoodDetaiState_Forward) {
        if (self.simpleDetailModel.buying_start_time.length == 0) {
            return nil;
        }
        return [NSDate dateFromString:self.simpleDetailModel.buying_start_time withFormat:self.simpleDetailModel.buying_start_time];
    } else if (self.state == GoodDetaiState_Panic) {
        if (self.simpleDetailModel.buying_end_time.length == 0) {
            return nil;
        }
        return [NSDate dateFromString:self.simpleDetailModel.buying_end_time withFormat:self.simpleDetailModel.buying_end_time];
    }
    return nil;
}

- (NSString *)tips {
    return [NSString stringWithFormat:@"%@%@", self.simpleDetailModel.buying_start_time, TEXT(@"准时开抢")];
}

- (NSString *)freeShippingStatus {
    if (self.simpleDetailModel.free_shipping_status == 0) {
        return [NSString stringWithFormat:@"%@:%@", TEXT(@"邮费"), self.simpleDetailModel.free_shipping_amount];
    } else if (self.simpleDetailModel.free_shipping_status == 1) {
        return [NSString stringWithFormat:@"%@%@%@", TEXT(@"满"), self.simpleDetailModel.shipping_amount, TEXT(@"包邮")];
    } else {
        return TEXT(@"全场包邮");
    }
}

- (NSString *)pointStr {
    return [NSString stringWithFormat:@"购买可送%@积分",self.simpleDetailModel.given_integral];
}

#pragma mark - 数据
- (void)getSimpleDetailDataWith:(long)goodsId {
    NSDictionary *paraDic = @{@"goodsId" : @(goodsId)};
    
    NSString *url = [NSString stringWithFormat:@"%@/mall/goodsDetail",BASEURL];
    __weak typeof(self) temp = self;
    self.loadSupport.loadEvent = NetLoadingEvent;
    
    [[BC_ToolRequest sharedManager] GET:url parameters:paraDic success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSNumber *codeNumber = [dic objectForKey:@"code"];
        NSLog(@"url = %@", operation.currentRequest);
        if(codeNumber.intValue == 0)
        {
            temp.simpleDetailModel = [BN_ShopGoodSimpleDetailModel mj_objectWithKeyValues:[dic objectForKey:@"result"]];
            if (temp.simpleDetailModel.type == 1) {
                temp.simpleDetailModel.buying_state = GoodDetaiState_Normal;
            }
        }
        else
        {
            NSString *errorStr = [dic objectForKey:@"remark"];
        }
        
        temp.loadSupport.loadEvent = codeNumber.intValue;
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
        temp.loadSupport.loadEvent = NetLoadFailedEvent;
    }];

}

- (void)addShoppingCartWith:(long)goodsId num:(int)num success:(void(^)())success failure:(void(^)(NSString *errorDescription))failure {
    num = MAX(1, num);
    NSDictionary *paraDic = nil;//@{@"goodsId" : @(goodsId),
                            //  @"num" : @(num)};
    NSString *url = [NSString stringWithFormat:@"%@/mall/shoppingCart?goodsId=%@&num=%@",BASEURL, @(goodsId), @(num)];
    
    [[BC_ToolRequest sharedManager] POST:url parameters:paraDic success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSLog(@"%@, %@", operation.currentRequest, paraDic);
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
                success();
            }
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        if (failure) {
            failure([error errorDescription]);
        }
    }];
    
}


@end
