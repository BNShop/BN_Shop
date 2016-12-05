//
//  BN_ShopPayment.m
//  BN_Shop
//
//  Created by Liya on 2016/12/5.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopPayment.h"

@implementation BN_ShopPayment
LY_SINGLETON_FOR_CLASS(BN_ShopPayment)


#pragma mark - 微信支付相关
//注册
- (void)wxRegisterApp {
    [WXApi registerApp:WX_APPID withDescription:@"BN_Shop"];
}

// 付费回来
- (void)onResp:(BaseResp*)resp
{
    NSLog(@"onResp: %@", resp);
    
    if ([resp isKindOfClass:[PayResp class]])
    {
        PayResp *response = (PayResp *)resp;
        self.wxPaymentHandler(response.returnKey, response.errCode);
//        switch (response.errCode)
//        {
//            case WXSuccess:
//                //服务器端查询支付通知或查询API返回的结果再提示成功
//                self.wxPaymentHandler(response.returnKey, response.errCode);
//                break;
//            default:
//                
//                break;
//        }
    }
    
}

- (void)sendReq:(PayReq *)payReq {
    [WXApi sendReq:payReq];
}


#pragma mark - 支付宝支付相关


@end
