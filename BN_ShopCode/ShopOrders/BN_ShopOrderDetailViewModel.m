//
//  BN_ShopOrderDetailViewModel.m
//  BN_Shop
//
//  Created by Liya on 2016/12/3.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopOrderDetailViewModel.h"
#import "NSArray+BlocksKit.h"
#import "NSError+Description.h"

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
    if (self.saleafter_state_name.length > 0) {
        return 1;
    }
    return 0;
}

- (NSString *)pay_typeName
{
    if (_pay_type == 1) {
        return @"微信支付";
    } else if (_pay_type == 2) {
        return @"支付宝支付";
    } else if (_pay_type == 3) {
        return @"平安银行支付";
    }
    return nil;
}

@end

@implementation BN_ShopOrderDetailViewModel
/*
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.detailModel = [[BN_ShopOrderDetailModel alloc] init];
        self.detailModel.use_integral = random()%2;
        self.detailModel.contact_person_name = @"方法尽快改";//联系人
        self.detailModel.pay_amount = @"80.0";//实付金额
        self.detailModel.order_state_name = @"待收货";//订单状态名
        self.detailModel.contact_person_phone_num = @"13599904508";//联系电话
        self.detailModel.freight_amount = @"12.00";//运费
        self.detailModel.courier_no = @"kduiajfi9089";//快递单号
        self.detailModel.order_id = @"dingdan9089";;//订单ID
        self.detailModel.goods_amount = @"300";//商品总金额
        self.detailModel.city = @"厦门";//城市
        self.detailModel.province = @"福建";//省
        self.detailModel.district = @"思明区";//String区
        self.detailModel.pay_type = random()%3+1;//1 微信支付2 支付宝支付3 平安银行支付
        self.detailModel.detailed_addr = @"软件园的那个门";//详细地址
        self.detailModel.create_time = @"2016-11-23 09:00";//String下单时间
        self.detailModel.integral_amount = @"12";//积分金额
        self.detailModel.comment_state_name = @"待支付";//评论状态名
        self.detailModel.saleafter_state_name = @"1";//售后状态名
        self.userProfile = [self.detailModel getUserAddress];
        
        self.detailModel.goodsList = [NSMutableArray array];
        BN_ShopOrderItemModel *item = [[BN_ShopOrderItemModel alloc] init];
        item.goods_num = 3;
        item.goods_name = @"果冻";
        item.pic_url = @"";;
        item.front_price  = @"29394.0";;//12.00,
        item.real_price = @"39.0";;//2.00,
        item.standard = @"standard";;//12",
        item.goods_id = 34;//
        item.order_id = 2456;
        item.order_no = @"980409";//订单编号
        item.order_state_name = @"kflkjf";//
        [self.detailModel.goodsList addObject:item];
        
    }
    return self;
}
 */

- (NSString *)realNeedPayStr {
    return [NSString stringWithFormat:@"¥%@", self.detailModel.pay_amount];
}

//商品总额
- (NSString *)shopAcountStr {
    return [NSString stringWithFormat:@"+¥%@", self.detailModel.goods_amount];
}
//运费
- (NSString *)shopFreightStr {
    return [NSString stringWithFormat:@"+¥%@", self.detailModel.freight_amount];
}
//积分抵扣
- (NSString *)shopVailableStr {
    if (self.detailModel.use_integral) {
        return [NSString stringWithFormat:@"-¥%@", self.detailModel.integral_amount];
    }
    return @"-¥0.00";
}


#pragma mark - 获取订单详情
- (void)getShoppingOrderDetail:(void(^)())success failure:(void(^)(NSString *errorDescription))failure {
    NSMutableDictionary *paraDic = nil;//[NSMutableDictionary dictionary];
    paraDic[@"orderId"] = self.order_id;
    __weak typeof(self) temp = self;
    NSString *url = [NSString stringWithFormat:@"%@/mall/orderDetail?orderId=%@",BASEURL, self.order_id];
    [[BC_ToolRequest sharedManager] GET:url parameters:paraDic success:^(NSURLSessionDataTask *operation, id responseObject) {
        NSDictionary *dic = responseObject;
        NSNumber *codeNumber = [dic objectForKey:@"code"];
        if (codeNumber.intValue != 0) {
            NSString *errorStr = [dic objectForKey:@"remark"];
            if (failure) {
                failure(errorStr);
            }
        } else {
            temp.detailModel = [BN_ShopOrderDetailModel mj_objectWithKeyValues:[dic objectForKey:@"result"]];
            temp.userProfile = [temp.detailModel getUserAddress];
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
