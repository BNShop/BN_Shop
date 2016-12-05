//
//  BN_ShopPayMentChannelModel.h
//  BN_Shop
//
//  Created by Liya on 2016/12/5.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BN_ShopPayMentChannelModel : NSObject
@property (nonatomic, assign) int payType;//1微信 2支付宝
@property (nonatomic, copy) NSString *payName;//微信支付，支付宝支付
@property (nonatomic, copy) NSString *payExplain;//微信支付，支付宝支付
@property (nonatomic, copy) NSString *payIconName;//支付的图像

+ (BN_ShopPayMentChannelModel *)paymentChannelModel:(NSString *)iconName payName:(NSString *)payName payExplain:(NSString *)payExplain payType:(int)payType;
@end
