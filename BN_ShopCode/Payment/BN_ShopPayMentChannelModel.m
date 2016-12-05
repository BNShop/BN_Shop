//
//  BN_ShopPayMentChannelModel.m
//  BN_Shop
//
//  Created by Liya on 2016/12/5.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import "BN_ShopPayMentChannelModel.h"

@implementation BN_ShopPayMentChannelModel

+ (BN_ShopPayMentChannelModel *)paymentChannelModel:(NSString *)iconName payName:(NSString *)payName payExplain:(NSString *)payExplain payType:(int)payType {
    BN_ShopPayMentChannelModel *channel = [[BN_ShopPayMentChannelModel alloc] init];
    channel.payIconName = iconName;
    channel.payName = payName;
    channel.payExplain = payExplain;
    channel.payType = payType;
    return channel;
}

@end
