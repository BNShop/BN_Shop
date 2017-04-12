//
//  BN_MySouvenirModel.h
//  BN_Shop
//
//  Created by yuze_huang on 2016/12/30.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BN_MySouvenirModel : NSObject
@property (nonatomic, assign) long specialId;//商品主键
@property (nonatomic, copy) NSString *specialName;//商品名称
@property (nonatomic, copy) NSString *coverImg;//商品图片地址
@property (nonatomic, copy) NSString *content;//商品描述
@property (nonatomic, assign) int isCollected;//收藏标志 0未收藏,1收藏


@end
