//
//  BN_ShopGoodSpecialCommentModel.h
//  BN_Shop
//
//  Created by Liya on 2016/11/30.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BN_ShopGoodSpecialCommentModel : NSObject

@property (nonatomic, assign) long commentId;//主键
@property (nonatomic, copy) NSString *remark;//评论描述
@property (nonatomic, assign) int scores;//分数
@property (nonatomic, strong) NSArray *pics;//评论图片集合
@property (nonatomic, copy) NSString *commentDate;//评论日期
@property (nonatomic, assign) int commentsNum;//评论条数
@property (nonatomic, assign) int likeNum;//评论条数
@property (nonatomic, assign) long userId;//发布者Id
@property (nonatomic, copy) NSString *userName;//发布者用户名称
@property (nonatomic, copy) NSString *userPicUrl;//发布者头像URL

@end
