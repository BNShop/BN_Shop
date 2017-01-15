//
//  PaymentMarioHeader.h
//  BN_Shop
//
//  Created by Liya on 2016/12/5.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#ifndef PaymentMarioHeader_h
#define PaymentMarioHeader_h

#define WX_APPID   @"wx94b0ac5b1ba8e1c3"
#define ALIPAY_AppScheme   @"alipaybnshop"

typedef NS_ENUM(NSUInteger, BN_ShopPaymentType) {
    BN_ShopPaymentType_WX = 0,
    BN_ShopPaymentType_Alipay = 1,
    BN_ShopPaymentType_Pingan = 2
};

typedef void (^WXPaymentCompletionHandler)(NSString *returnKey, int errCode);
typedef void (^AlipayPaymentCompletionHandler)(NSString *aliCheckRecepitData, int resultStatus, NSString *memo);

#endif /* PaymentMarioHeader_h */
