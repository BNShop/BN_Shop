//
//  BN_ShopOrderUserProfileViewModel.h
//  BN_Shop
//
//  Created by Liya on 16/11/14.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BN_ShopUserAddressModel.h"
#import "BN_ShopOrderItemProtocol.h"
#import "BN_ShopOrderItemModel.h"
#import "BN_ShopOrderCartItemModel.h"
#import "BN_ShopHeader.h"

@interface BN_ShopOrderUserProfileViewModel : NSObject

@property (nonatomic, strong) BN_ShopUserAddressModel *userProfile;
@property (nonatomic, assign, getter=isTagged) BOOL tagged;

- (NSString *)provinceAndCity;
- (NSString *)telNum;

@end
