//
//  BN_ShopHomeCategoryViewModel.h
//  BN_Shop
//
//  Created by Liya on 16/11/17.
//  Copyright © 2016年 GL_RunMan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BN_ShopHomeCategoryViewModel : NSObject

@property (strong, nonatomic, readonly) NSArray *categorys;

- (instancetype)initWith:(NSArray *)items;
- (void)initCategorysWith:(NSArray *)items;
- (id)categoryWithIndex:(NSInteger)index;
- (NSArray *)categoryTitles;

@end
