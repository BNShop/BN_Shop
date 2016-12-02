//
//  BN_ShopGoodSpecialModel.h
//  BN_Shop
//
//  Created by Liya on 2016/11/29.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BN_ShopGoodSpecialModel : NSObject
@property (nonatomic, assign) long relId;//专题与对象关系ID
@property (nonatomic, assign) int type;//对象类型 1美食 2 民宿 3 景点  4 伴手礼
@property (nonatomic, assign) long objId;//对应的对象ID 如类型是景点,则本ID为关联的景点id
@property (nonatomic, copy) NSString *titleDisplay;//显示标题
@property (nonatomic, copy) NSString *viceTitleDisplay;//副显示标题
@property (nonatomic, copy) NSString *imageUrl1;//图片1
@property (nonatomic, copy) NSString *imageUrl2;//图片2
@property (nonatomic, copy) NSString *contentDisplay;//显示内容 富文本
@property (nonatomic, assign) int likeNum;//点赞次数
@property (nonatomic, assign) int commentsNum;//评论条数
@property (nonatomic, assign) int collecteNum;//收藏次数
@property (nonatomic, assign) int isCollected;//收藏标志 0未收藏 1：收藏
@property (nonatomic, assign) int isLiked;//点赞标志 0未点赞 1：点赞
@property (nonatomic, copy) NSString *real_price;//商品售价


- (NSAttributedString *)contentAttributed;
- (NSAttributedString *)priceAttributed;
- (NSString *)followStr;

@end
