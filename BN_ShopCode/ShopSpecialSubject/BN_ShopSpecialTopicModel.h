//
//  BN_ShopSpecialTopicModel.h
//  BN_Shop
//
//  Created by Liya on 2016/11/30.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BN_ShopspecialTagModel.h"

@interface BN_ShopSpecialTopicModel : NSObject
@property (nonatomic, assign) long special_id;//商品主键
@property (nonatomic, copy) NSString *content;//专题内容
@property (nonatomic, copy) NSString *cover_img;//专题封面图
@property (nonatomic, copy) NSString *name;//专题名称
@property (nonatomic, strong) NSArray<BN_ShopspecialTagModel*> *tags;
@property (nonatomic, copy) NSString *tagName;

@end
