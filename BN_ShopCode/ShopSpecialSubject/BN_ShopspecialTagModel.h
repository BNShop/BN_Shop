//
//  BN_ShopspecialTagModel.h
//  BN_Shop
//
//  Created by Liya on 2016/12/2.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BN_ShopHeader.h"

@interface BN_ShopspecialTagModel : NSObject
@property (nonatomic, assign) long tagId;//主键
@property (nonatomic, copy) NSString *tagName;//标签名称
@end
