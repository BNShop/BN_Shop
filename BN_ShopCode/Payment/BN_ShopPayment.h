//
//  BN_ShopPayment.h
//  BN_Shop
//
//  Created by Liya on 2016/12/5.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYSingleton.h"
#import "PaymentMarioHeader.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>

@interface BN_ShopPayment : NSObject <WXApiDelegate>
LY_SINGLETON_FOR_CLASS_HEADER(BN_ShopPayment)

@property (nonatomic, copy) WXPaymentCompletionHandler wxPaymentHandler;
@property (nonatomic, copy) AlipayPaymentCompletionHandler alipayPaymentHandler;

//微信注册
- (void)wxRegisterApp;
//发起微信支付请求
- (void)sendReq:(PayReq *)payReq;

//支付宝
- (void)sendAlipay:(NSString *)orderString;
- (void)alipayCallBackWith:(NSDictionary *)resultDic;
@end
