//
//  BN_ShopUserProfileProtocol.h
//  BN_Shop
//
//  Created by Liya on 16/11/15.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BN_ShopUserProfileProtocol <NSObject>

@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *district;
@property (nonatomic, copy) NSString *detailedAddr;
@property (nonatomic, copy) NSString *contactPersonName;
@property (nonatomic, copy) NSString *contactPersonPhoneNum;

@end
