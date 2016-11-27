//
//  BN_ShopHomeCategoryViewModel.h
//  BN_Shop
//
//  Created by Liya on 16/11/17.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>

//分类
@interface BN_ShopCategoryModel : NSObject

@property (nonatomic, copy) NSString *name; //分类名称
@property (nonatomic, assign) long category_id;//id

@end

@interface BN_ShopHomeCategoryViewModel : NSObject

@property (strong, nonatomic) NSMutableArray<BN_ShopCategoryModel*> *categorys;

- (void)getCategoryArray;

- (id)categoryWithIndex:(NSInteger)index;
- (NSArray *)categoryTitles;

@end
