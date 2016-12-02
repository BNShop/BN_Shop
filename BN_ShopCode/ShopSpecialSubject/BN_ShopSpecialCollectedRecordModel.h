//
//  BN_ShopSpecialCollectedRecordModel.h
//  BN_Shop
//
//  Created by Liya on 2016/11/30.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BN_ShopSpecialCollectedRecordModel : NSObject

@property (nonatomic, assign) long userId;//主键
@property (nonatomic, copy) NSString *userName;//收藏用户名称
@property (nonatomic, copy) NSString *userPicUrl;//收藏头像URL

@end
