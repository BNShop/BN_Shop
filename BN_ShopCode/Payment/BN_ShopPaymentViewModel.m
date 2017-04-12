//
//  BN_ShopPaymentViewModel.m
//  BN_Shop
//
//  Created by Liya on 2016/12/5.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopPaymentViewModel.h"
#import "BN_ShopPayMentChannelModel.h"


@implementation BN_ShopPaymentViewModel


+ (BN_ShopPaymentViewModel *)paymentViewModelWith:(NSArray *)orderIds type:(BN_ShopPaymentType)type needPay:(NSString *)needPay {
    BN_ShopPaymentViewModel *model = [[BN_ShopPaymentViewModel alloc] init];
    model.orderIds = orderIds;
    model.paymentType = type;
    model.needPay = needPay;
    
    return model;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSArray *array = @[[BN_ShopPayMentChannelModel paymentChannelModel:@"Shop_WXPay" payName:TEXT(@"微信支付") payExplain:TEXT(@"微信安全支付") payType:BN_ShopPaymentType_WX], [BN_ShopPayMentChannelModel paymentChannelModel:@"Shop_Alipay" payName:TEXT(@"支付宝支付") payExplain:TEXT(@"支付宝安全支付") payType:BN_ShopPaymentType_Alipay], [BN_ShopPayMentChannelModel paymentChannelModel:@"Shop_Pingan" payName:TEXT(@"平安支付") payExplain:TEXT(@"平安安全支付") payType:BN_ShopPaymentType_Pingan]];
        self.dataSource = [[TableDataSource alloc] initWithItems:array cellIdentifier:nil configureCellBlock:nil];
        self.paymentType = BN_ShopPaymentType_WX;
    }
    return self;
}


- (void)setPaymentType:(BN_ShopPaymentType)paymentType {
    if (paymentType < BN_ShopPaymentType_WX) {
        _paymentType = BN_ShopPaymentType_WX;
    } else if (paymentType > BN_ShopPaymentType_Alipay) {
        _paymentType = BN_ShopPaymentType_Alipay;
    } else {
        _paymentType = paymentType;
    }
}


@end
