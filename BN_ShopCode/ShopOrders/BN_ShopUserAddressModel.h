//
//  BN_ShopUserAddressModel.h
//  BN_Shop
//
//  Created by Liya on 2016/12/3.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BN_ShopUserAddressModel : NSObject

@property (nonatomic, assign) int is_default;//是否默认
@property (nonatomic, assign) int province_id;//
@property (nonatomic, assign) int district_id;
@property (nonatomic, assign) int city_id;
@property (nonatomic, assign) int address_id;
@property (nonatomic, copy) NSString *prov;
@property (nonatomic, copy) NSString *dist;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *name;

- (NSString *)provinceAndCity;
- (NSString *)telNum;
@end
