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
        
        
        if (response.returnKey.length == 0) {
            if (response.errCode == WXErrCodeUserCancel) {
                response.returnKey = TEXT(@"用户取消支付");
            } else if (response.errCode == WXErrCodeUnsupport) {
                response.returnKey = TEXT(@"微信不支持");
            } else {
                response.returnKey = TEXT(@"支付失败");
            }
        }
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
- (void)sendAlipay:(NSString *)orderString {
    // NOTE: 调用支付结果开始支付
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:ALIPAY_AppScheme callback:^(NSDictionary *resultDic) {
        [[BN_ShopPayment sharedInstance] alipayCallBackWith:resultDic];
    }];
}

- (void)alipayCallBackWith:(NSDictionary *)resultDic {
    NSLog(@"reslut = %@",resultDic);
    int resultStatus = [resultDic[@"resultStatus"] intValue];
    NSString *result = resultDic[@"result"];
    NSString *memo = resultDic[@"memo"];
    
    if (result)
    {
        //是否支付成功
        if (9000 == resultStatus)
        {
            //获取验签
            NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithDictionary:resultDic];
            [muDic setObject:muDic[@"resultStatus"] forKey:@"ResultStatus"];
            [muDic removeObjectForKey:@"resultStatus"];
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:muDic
                                                               options:NSJSONWritingPrettyPrinted
                                                                 error:&error];
            NSString *aliCheckRecepitData = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            self.alipayPaymentHandler (aliCheckRecepitData, resultStatus, memo);
        } else {
            self.alipayPaymentHandler (nil, resultStatus, memo);
        }
    }
}

@end
