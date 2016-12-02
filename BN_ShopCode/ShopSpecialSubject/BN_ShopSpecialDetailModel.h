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

@interface BN_ShopSpecialDetailModel : NSObject

@property (nonatomic, assign) long specialId;//专题ID
@property (nonatomic, copy) NSString *name;//名称
@property (nonatomic, copy) NSString *content;//专题描述
@property (nonatomic, copy) NSString *coverImagesUrl;//封面图片
@property (nonatomic, copy) NSString *shareUrl;//分享URL
@property (nonatomic, copy) NSString *shareTitle;//分享标题
@property (nonatomic, copy) NSString *shareContent;//分享内容
@property (nonatomic, assign) int isCollected;//收藏标志 0未收藏 1：收藏
@property (nonatomic, assign) int collecteNum;//收藏次数
@property (nonatomic, assign) int likeNum;//点赞次数
@property (nonatomic, assign) int commentsNum;//评论条数
@property (nonatomic, strong) NSArray<BN_ShopspecialTagModel*> *tags;//标签列表
@property (nonatomic, strong) NSArray<BN_ShopSpecialCollectedRecordModel*> *collectedRecord;//收藏记录（具体几个后台控制）
@property (nonatomic, strong) NSArray<BN_ShopGoodSpecialCommentModel*> *commentsRecord;//评论记录（具体几个后台控制）

@end
