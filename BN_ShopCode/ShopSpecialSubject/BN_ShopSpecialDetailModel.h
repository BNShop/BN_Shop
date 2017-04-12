//
//  BN_ShopSpecialDetailModel.h
//  BN_Shop
//
//  Created by Liya on 2016/11/30.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BN_ShopGoodSpecialCommentModel.h"
#import "BN_ShopGoodSpecialModel.h"
#import "BN_ShopSpecialCollectedRecordModel.h"
#import "BN_ShopspecialTagModel.h"
#import "BN_ShopHeader.h"

@interface BN_ShopSpecialDetailModel : NSObject

@property (nonatomic, assign) long specialId;//专题ID
@property (nonatomic, copy) NSString *name;//名称
@property (nonatomic, copy) NSString *content;//专题描述
@property (nonatomic, copy) NSString *cover_img;//封面图片
@property (nonatomic, assign) int total_collected;//收藏次数
@property (nonatomic, assign) int total_like;//喜欢次数
@property (nonatomic, assign) int total_comment;//评论次数
@property (nonatomic, assign) int is_recommend;//是否是推荐
@property (nonatomic, copy) NSString *remarkd;//
@property (nonatomic, assign) int isAlreadyCollect;//是否已经收藏 1：是 0：否
@property (nonatomic, copy) NSString *title_display;//显示标题
@property (nonatomic, copy) NSString *vice_title_display;//显示富标题
@property (nonatomic, copy) NSString *content_display;//显示内容

@end
