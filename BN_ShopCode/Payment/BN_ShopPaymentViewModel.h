//
//  BN_ShopPaymentViewModel.h
//  BN_Shop
//
//  Created by Liya on 2016/12/5.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PaymentMarioHeader.h"
#import "TableDataSource.h"

@interface BN_ShopPaymentViewModel : NSObject
@property (assign, nonatomic) BN_ShopPaymentType paymentType;
@property (copy, nonatomic) NSString *needPay;//需要支付的钱
@property (strong, nonatomic) NSArray *orderIds;//支付的ids
@property (strong, nonatomic) TableDataSource *dataSource;

+ (BN_ShopPaymentViewModel *)paymentViewModelWith:(NSArray *)orderIds type:(BN_ShopPaymentType)type needPay:(NSString *)needPay;
@end
