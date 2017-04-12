//
//  BN_ShopHomeCategoryViewModel.h
//  BN_Shop
//
//  Created by Liya on 16/11/17.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BN_ShopCategoryModel.h"
#import "BN_ShopHeader.h"

@interface BN_ShopHomeCategoryViewModel : NSObject

@property (strong, nonatomic) NSMutableArray<BN_ShopCategoryModel*> *categorys;

- (void)getCategoryArray;

- (id)categoryWithIndex:(NSInteger)index;
- (NSArray *)categoryTitles;

@end
