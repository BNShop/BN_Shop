//
//  BN_ShopGoodDetailCommentsCellModel.h
//  BN_Shop
//
//  Created by Liya on 2016/11/20.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BN_ShopGoodDetailCommentsCellModel : NSObject

@property (nonatomic, copy) NSString *iconUrl;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *good;
@property (nonatomic, strong) NSArray *imgUrls;

@end
