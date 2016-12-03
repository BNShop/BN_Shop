//
//  BN_ShopOrderDetailViewModel.m
//  BN_Shop
//
//  Created by Liya on 2016/12/3.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopOrderDetailViewModel.h"
#import "NSArray+BlocksKit.h"

@implementation BN_ShopOrderDetailModel


- (BN_ShopUserAddressModel *)getUserAddress {
    
    BN_ShopUserAddressModel *model = [[BN_ShopUserAddressModel alloc] init];
    model.prov = self.province;
    model.dist = self.district;
    model.city = self.city;
    model.phone = self.contact_person_phone_num;
    model.address = self.detailed_addr;
    model.name = self.contact_person_name;
    return model;
}

- (void)setGoodsList:(NSMutableArray *)goodsList {
    _goodsList = [goodsList bk_map:^id (id obj) {
        return [BN_ShopOrderItemModel mj_objectWithKeyValues:obj];
    }];
}

- (int)orderState {
//    0 代之父 1代收货 2代评价 3已完成
    if ([_order_state_name isEqualToString:@"待评价"]) {
        return BN_ShopOrderState_Recommend;
    } else if ([_order_state_name isEqualToString:@"已完成"]) {
        return BN_ShopOrderState_Finish;
    } else if ([_order_state_name isEqualToString:@"待收货"]) {
        return BN_ShopOrderState_Take;
    }
    return BN_ShopOrderState_Pay;
}

- (int)saleafter {
    return 0;
}

- (NSString *)pay_typeName
{
    if (_pay_type == 0) {
        return @"微信支付";
    } else if (_pay_type == 0) {
        return @"支付宝支付";
    } else if (_pay_type == 0) {
        return @"平安银行支付";
    }
    return nil;
}

@end

@implementation BN_ShopOrderDetailViewModel

#pragma mark - 获取订单详情
- (void)getShoppingOrderDetail:(void(^)())success failure:(void(^)(NSString *errorDescription))failure {
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    paraDic[@"orderId"] = self.order_id;
    __weak typeof(self) temp = self;
    NSString *url = [NSString stringWithFormat:@"%@/mall/orderDetail",BASEURL];
    [[BC_ToolRequest sharedManager] POST:url parameters:paraDic success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSNumber *codeNumber = [dic objectForKey:@"code"];
        if (codeNumber.intValue != 0) {
            temp.detailModel = [BN_ShopOrderDetailModel mj_objectWithKeyValues:[dic objectForKey:@"result"]];
            temp.userProfile = [temp.detailModel getUserAddress];
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
