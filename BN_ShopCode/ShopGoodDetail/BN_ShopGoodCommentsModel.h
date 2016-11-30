//
//  BN_ShopGoodCommentsModel.h
//  BN_Shop
//
//  Created by Liya on 2016/11/29.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BN_ShopGoodCommentsModel : NSObject
@property (nonatomic, assign) long commentId;//主键
@property (nonatomic, assign) long userId;//用户id
@property (nonatomic, copy) NSString *userName;//g用户名称
@property (nonatomic, copy) NSString *userPicUrl;//用户头像地址
@property (nonatomic, copy) NSString *remark;//评论描述
@property (nonatomic, assign) int scores;//评论得分,采用100分制，20分一颗星，100分5颗星
@property (nonatomic, copy) NSString *commentDate;//评论时间
@property (nonatomic, strong) NSArray *pics;//评论的图片 pics":[{"imageUrl":"http://oggvb32dz.bkt.clouddn.com/1479353192.jpg"}]}]
@property (nonatomic, assign) int commentsNum;//评论数
@end
