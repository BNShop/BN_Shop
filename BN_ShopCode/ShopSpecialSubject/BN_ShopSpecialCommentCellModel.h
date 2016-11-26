//
//  BN_ShopSpecialCommentCellModel.h
//  BN_Shop
//
//  Created by Liya on 2016/11/22.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BN_ShopSpecialCommentCellModel : NSObject

@property (nonatomic, copy) NSString *iconUrl;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *coment;
@property (nonatomic, copy) NSString *follow;
@property (nonatomic, assign) BOOL isFollow;
@property (nonatomic, strong) NSArray *imgUrls;

@end
