//
//  BN_ShopCategoryModel.h
//  BN_Shop
//
//  Created by Liya on 2016/11/27.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BN_ShopSecondCategoryModel : NSObject
@property (nonatomic, assign) long category_id;//分类主键
@property (nonatomic, copy) NSString *name;//分类名称
@property (nonatomic, copy) NSString *pic_horizontal_url;//图片

@end

@interface BN_ShopCategoryModel : NSObject

@property (nonatomic, assign) long category_id;//分类主键
@property (nonatomic, copy) NSString *name;//分类名称

@property (nonatomic, strong) NSMutableArray<BN_ShopSecondCategoryModel*> *secondCategories;

@end
