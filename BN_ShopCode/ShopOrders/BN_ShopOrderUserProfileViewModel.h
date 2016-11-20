//
//  BN_ShopOrderUserProfileViewModel.h
//  BN_Shop
//
//  Created by Liya on 16/11/14.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BN_ShopUserProfileProtocol.h"

@interface BN_ShopOrderUserProfileViewModel : NSObject

@property (nonatomic, strong) id<BN_ShopUserProfileProtocol> userProfile;
@property (nonatomic, assign, getter=isTagged) BOOL tagged;

- (NSString *)provinceAndCity;
- (NSString *)telNum;

@end
