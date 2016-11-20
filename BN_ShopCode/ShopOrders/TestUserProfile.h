//
//  TestUserProfile.h
//  BN_Shop
//
//  Created by Liya on 16/11/15.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BN_ShopUserProfileProtocol.h"

@interface TestUserProfile : NSObject <BN_ShopUserProfileProtocol>

@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *district;
@property (nonatomic, copy) NSString *detailedAddr;
@property (nonatomic, copy) NSString *contactPersonName;
@property (nonatomic, copy) NSString *contactPersonPhoneNum;

@end
